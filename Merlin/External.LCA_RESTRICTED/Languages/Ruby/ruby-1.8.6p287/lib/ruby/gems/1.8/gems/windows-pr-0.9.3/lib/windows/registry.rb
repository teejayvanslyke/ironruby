require 'windows/file'

module Windows
   module Registry
      API.auto_namespace = 'Windows::Registry'
      API.auto_constant  = true
      API.auto_method    = true
      API.auto_unicode   = true
            
      include Windows::File
      
      HKEY_CLASSES_ROOT        = 0x80000000
      KEY_CURRENT_USER         = 0x80000001
      HKEY_LOCAL_MACHINE       = 0x80000002
      HKEY_USERS               = 0x80000003
      HKEY_PERFORMANCE_DATA    = 0x80000004
      HKEY_PERFORMANCE_TEXT    = 0x80000050
      HKEY_PERFORMANCE_NLSTEXT = 0x80000060
      HKEY_CURRENT_CONFIG      = 0x80000005
      HKEY_DYN_DATA            = 0x80000006

      KEY_QUERY_VALUE         = 0x0001
      KEY_SET_VALUE           = 0x0002
      KEY_CREATE_SUB_KEY      = 0x0004
      KEY_ENUMERATE_SUB_KEYS  = 0x0008
      KEY_NOTIFY              = 0x0010
      KEY_CREATE_LINK         = 0x0020
      KEY_WOW64_32KEY         = 0x0200
      KEY_WOW64_64KEY         = 0x0100
      KEY_WOW64_RES           = 0x0300

      KEY_READ = (STANDARD_RIGHTS_READ|KEY_QUERY_VALUE|KEY_ENUMERATE_SUB_KEYS|
                  KEY_NOTIFY) & (~SYNCHRONIZE)

      KEY_WRITE = (STANDARD_RIGHTS_WRITE|KEY_SET_VALUE|
                  KEY_CREATE_SUB_KEY) & (~SYNCHRONIZE)

      KEY_EXECUTE = KEY_READ & (~SYNCHRONIZE)

      KEY_ALL_ACCESS = (STANDARD_RIGHTS_ALL|KEY_QUERY_VALUE|KEY_SET_VALUE|
                  KEY_CREATE_SUB_KEY|KEY_ENUMERATE_SUB_KEYS|KEY_NOTIFY|
                  KEY_CREATE_LINK) & (~SYNCHRONIZE)
                  
      REG_OPTION_RESERVED       = 0
      REG_OPTION_NON_VOLATILE   = 0
      REG_OPTION_VOLATILE       = 1
      REG_OPTION_CREATE_LINK    = 2
      REG_OPTION_BACKUP_RESTORE = 4
      REG_OPTION_OPEN_LINK      = 8

      REG_LEGAL_OPTION = REG_OPTION_RESERVED|REG_OPTION_NON_VOLATILE|
         REG_OPTION_VOLATILE|REG_OPTION_CREATE_LINK|REG_OPTION_BACKUP_RESTORE|
         REG_OPTION_OPEN_LINK

      REG_CREATED_NEW_KEY     = 1
      REG_OPENED_EXISTING_KEY = 2

      REG_STANDARD_FORMAT = 1
      REG_LATEST_FORMAT   = 2
      REG_NO_COMPRESSION  = 4

      REG_WHOLE_HIVE_VOLATILE = 1
      REG_REFRESH_HIVE        = 2
      REG_NO_LAZY_FLUSH       = 4
      REG_FORCE_RESTORE       = 8

      REG_FORCE_UNLOAD = 1

      REG_NOTIFY_CHANGE_NAME        = 1
      REG_NOTIFY_CHANGE_ATTRIBUTES  = 2
      REG_NOTIFY_CHANGE_LAST_SET    = 4
      REG_NOTIFY_CHANGE_SECURITY    = 8

      REG_LEGAL_CHANGE_FILTER = REG_NOTIFY_CHANGE_NAME|
         REG_NOTIFY_CHANGE_ATTRIBUTES|REG_NOTIFY_CHANGE_LAST_SET|
         REG_NOTIFY_CHANGE_SECURITY

      REG_NONE                       = 0
      REG_SZ                         = 1
      REG_EXPAND_SZ                  = 2    
      REG_BINARY                     = 3
      REG_DWORD                      = 4
      REG_DWORD_LITTLE_ENDIAN        = 4
      REG_DWORD_BIG_ENDIAN           = 5
      REG_LINK                       = 6
      REG_MULTI_SZ                   = 7
      REG_RESOURCE_LIST              = 8 
      REG_FULL_RESOURCE_DESCRIPTOR   = 9
      REG_RESOURCE_REQUIREMENTS_LIST = 10 
      REG_QWORD                      = 11 
      REG_QWORD_LITTLE_ENDIAN        = 11

      API.new('RegCloseKey', 'L', 'L', 'advapi32')
      API.new('RegConnectRegistry', 'PLP', 'L', 'advapi32')
      API.new('RegCreateKey', 'LPP', 'L', 'advapi32')
      API.new('RegCreateKeyEx', 'LPLPLLPPP', 'L', 'advapi32')
      API.new('RegDeleteKey', 'LP', 'L', 'advapi32')
      API.new('RegDeleteValue', 'LP', 'L', 'advapi32')
      API.new('RegDisablePredefinedCache', 'V', 'L', 'advapi32')
      API.new('RegEnumKey', 'LLPL', 'L', 'advapi32')
      API.new('RegEnumKeyEx', 'LLPPPPP', 'L', 'advapi32')
      API.new('RegEnumValue', 'LLPPPPPP', 'L', 'advapi32')
      API.new('RegFlushKey', 'L', 'L', 'advapi32')
      API.new('RegLoadKey', 'LPP', 'L', 'advapi32')
      API.new('RegNotifyChangeKeyValue', 'LILLI', 'L', 'advapi32')
      API.new('RegOpenCurrentUser', 'LP', 'L', 'advapi32')
      API.new('RegOpenKey', 'LPP', 'L', 'advapi32')
      API.new('RegOpenKeyEx', 'LPLLP', 'L', 'advapi32')
      API.new('RegOpenUserClassesRoot', 'LLLP', 'L', 'advapi32')
      API.new('RegOverridePredefKey', 'LL', 'L', 'advapi32')
      API.new('RegQueryInfoKey', 'LPPPPPPPPPPP', 'L', 'advapi32')
      API.new('RegQueryMultipleValues', 'LPLPP', 'L', 'advapi32')
      API.new('RegQueryValueEx', 'LPPPPP', 'L', 'advapi32')
      API.new('RegReplaceKey', 'LPPP', 'L', 'advapi32')
      API.new('RegRestoreKey', 'LPL', 'L', 'advapi32')
      API.new('RegSaveKey', 'LPP', 'L', 'advapi32')
      API.new('RegSetValueEx', 'LPLLPL', 'L', 'advapi32')
      API.new('RegUnLoadKey', 'LP', 'L', 'advapi32')
      
      # Windows XP or later
      begin
         API.new('RegSaveKeyEx', 'LPPL', 'L', 'advapi32')
      rescue Windows::API::Error
         # Do nothing - not supported on current platform.  It's up to you to
         # check for the existence of the constant in your code.
      end
   end
end
