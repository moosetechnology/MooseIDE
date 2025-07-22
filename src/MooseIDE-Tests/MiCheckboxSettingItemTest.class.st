Class {
	#name : 'MiCheckboxSettingItemTest',
	#superclass : 'MiAbstractSettingItemTest',
	#category : 'MooseIDE-Tests-Settings',
	#package : 'MooseIDE-Tests',
	#tag : 'Settings'
}

{ #category : 'running' }
MiCheckboxSettingItemTest >> initialValue [
	^true
]

{ #category : 'running' }
MiCheckboxSettingItemTest >> settingItemInstance [
	^MiCheckboxSettingItem new
]

{ #category : 'running' }
MiCheckboxSettingItemTest >> someOtherValue [
	^false
]
