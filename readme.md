# Note for current fork:
* To be honest, after looking at this module and working on it for some time, it feels like importing KeePassLib and working with it directly is easier/faster than using PoSHKeePass module. So i doubt i will update it for much longer.

# PowerShell KeePass

[PoShKeePass](https://www.powershellgallery.com/packages/PoShKeePass) is a PowerShell module that combines the ease of the PowerShell cli and the extensibility of the [KeePassLib API](http://keepass.info/help/v2/setup.html) to provide a powerful and easy to use management and automating platform for [KeePass](http://keepass.info/) databases.

## Features

1. **Database Configuration Profiles** - Supports multiple databases and authentication options.
2. **Getting, Creating, Updating, and Removing KeePass Entries and Groups** - All of these perform as much automatic database authentication as possible using the database configuration profile. For databases that use a masterkey (password) it will prompt for it.
3. **Generating KeePass Passwords** - Supports most character sets and advanced keepass options. Also supports creating password profiles that can be specified to create a new password with the same rule set.
4. **(Work in Progress) Custom icon management** - Allows user to get custom icons (list all, find by index, find by name, find by uuid), rename custom icons, set custom icons for Entries/Groups. Possible future features: Add new custom icons to database, remove custom icons from database

## Getting Started

### Install

1. Download latest release .zip file.
2. Extract into your 'Modules' folder. (You can get path to 'Modules' folder by running Powershell command: $env:PSModulePath)
3. ???
4. Profit.

### Documentation

Please check out our [Getting Started](https://github.com/PSKeePass/PoShKeePass/wiki/Getting-Started) documentation on our [wiki](https://github.com/PSKeePass/PoShKeePass/wiki).

## Important Notes & Reminders

1. Please always keep up to date **backups** of your KeePass database files .kdbx and .key files.
2. As of version 2.1.3.1 the module uses the KeePassLib 2.49 which is included in the module.
3. Module is tested with KeePass version 2.49. Correct work with other versions (especially old ones) is NOT guaranteed
4. This module was built and tested in PowerShell 5.1 on Windows 10 but should work in PowerShell 4 and Windows 8.1 and Server 2012 R2 and up. It may work in some earlier versions but is currently untested and not supported.

## Changelog

Please review the [changelog document](https://github.com/PSKeePass/PoShKeePass/blob/master/changelog.md) for a full history.

## v.2.1.4.1
* Added function:
```powershell
Rename-KeePassCustomIcon
```
* Code refactoring of other 'Custom icon' related functions

## v.2.1.4.0
* Added function:
```powershell
Get-KeePassCustomIcon
```
* Added internal function:
```powershell
Get-KPCustomIcon
```
* Updated funtions:
```powershell
Update-KeePassEntry
Update-KeePassGroup
```
* You can now provide '-CustomIconUuid' parameter to updated functions to set custom icon for selected Entry/Group

## v.2.1.3.1
* Update KeePassLib to 2.49

* Added new properties to KPPSObject:
  * CustomIconUuid - returns UUID of selected custom icon of group/entry
  * CustomStrings - returns hashtable of user added strings of current entry
  * Attachments - returns hashtable of attachments of current entry

## License

Copyright (c) 2019 [John Klann](https://github.com/jkdba). All rights reserved.

Licensed under the [MIT](https://github.com/PSKeePass/PoShKeePass/blob/master/license) License.
