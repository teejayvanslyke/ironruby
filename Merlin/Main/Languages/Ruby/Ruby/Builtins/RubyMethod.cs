﻿/* ****************************************************************************
 *
 * Copyright (c) Microsoft Corporation. 
 *
 * This source code is subject to terms and conditions of the Microsoft Public License. A 
 * copy of the license can be found in the License.html file at the root of this distribution. If 
 * you cannot locate the  Microsoft Public License, please send an email to 
 * ironruby@microsoft.com. By using this source code in any fashion, you are agreeing to be bound 
 * by the terms of the Microsoft Public License.
 *
 * You must not remove this notice, or any other, from this software.
 *
 *
 * ***************************************************************************/

using System;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using IronRuby.Runtime;
using IronRuby.Runtime.Calls;
using Microsoft.Scripting.Utils;
using Ast = System.Linq.Expressions.Expression;
using AstUtils = Microsoft.Scripting.Ast.Utils;

namespace IronRuby.Builtins {
    public partial class RubyMethod {
        private readonly object _target;
        private readonly string/*!*/ _name;
        private readonly RubyMemberInfo/*!*/ _info;
        private BlockDispatcherUnsplatN _procDispatcher;

        public object Target {
            get { return _target; }
        }

        public RubyMemberInfo/*!*/ Info {
            get { return _info; }
        }

        public string/*!*/ Name {
            get { return _name; } 
        }

        public RubyMethod(object target, RubyMemberInfo/*!*/ info, string/*!*/ name) {
            ContractUtils.RequiresNotNull(info, "info");
            ContractUtils.RequiresNotNull(name, "name");
                        
            _target = target;
            _info = info;
            _name = name;
        }

        public RubyClass/*!*/ GetTargetClass() {
            return _info.Context.GetClassOf(_target);
        }

        public virtual Proc/*!*/ ToProc(RubyScope/*!*/ scope) {
            ContractUtils.RequiresNotNull(scope, "scope");

            if (_procDispatcher == null) {
                var site = CallSite<Func<CallSite, object, object, object>>.Create(
                    // TODO: use InvokeBinder
                    RubyCallAction.Make(
                        scope.RubyContext, "call",
                        new RubyCallSignature(1, RubyCallFlags.HasImplicitSelf | RubyCallFlags.HasSplattedArgument)
                    )
                );

                var block = new BlockCallTargetUnsplatN((blockParam, self, args, unsplat) => {
                    // block takes no parameters but unsplat => all actual arguments are added to unsplat:
                    Debug.Assert(args.Length == 0);

                    return site.Target(site, this, unsplat);
                });

                _procDispatcher = new BlockDispatcherUnsplatN(block, 0, 
                    BlockDispatcher.MakeAttributes(BlockSignatureAttributes.HasUnsplatParameter, _info.GetArity())
                );
            }

            // TODO: 
            // MRI: source file/line are that of the to_proc method call:
            return new Proc(ProcKind.Block, scope.SelfObject, scope, null, 0, _procDispatcher);
        }

        #region Dynamic Operations

        internal virtual void BuildInvoke(MetaObjectBuilder/*!*/ metaBuilder, CallArguments/*!*/ args) {
            Assert.NotNull(metaBuilder, args);
            Debug.Assert(args.Target == this);

            // first argument must be this method:
            metaBuilder.AddRestriction(Ast.Equal(args.TargetExpression, AstUtils.Constant(this)));

            // set the target (becomes self in the called method):
            args.SetTarget(AstUtils.Constant(_target), _target);

            _info.BuildCall(metaBuilder, args, _name);
        }

        #endregion

        #region Curried

        // TODO: currently used only to curry a method name for method_missing, but could be easily extended to support general argument currying
        public sealed class Curried : RubyMethod {
            private readonly string/*!*/ _methodNameArg;

            internal Curried(object target, RubyMemberInfo/*!*/ info, string/*!*/ methodNameArg)
                : base(target, info, "method_missing") {
                _methodNameArg = methodNameArg;
            }

            internal override void BuildInvoke(MetaObjectBuilder/*!*/ metaBuilder, CallArguments/*!*/ args) {
                args.InsertMethodName(_methodNameArg);
                base.BuildInvoke(metaBuilder, args);
            }

            public override Proc/*!*/ ToProc(RubyScope/*!*/ scope) {
                throw new NotSupportedException();
            }
        }

        #endregion
    }
}
