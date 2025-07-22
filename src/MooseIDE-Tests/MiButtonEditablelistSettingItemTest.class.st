Class {
	#name : 'MiButtonEditablelistSettingItemTest',
	#superclass : 'MiAbstractSettingItemTest',
	#category : 'MooseIDE-Tests-Settings',
	#package : 'MooseIDE-Tests',
	#tag : 'Settings'
}

{ #category : 'running' }
MiButtonEditablelistSettingItemTest >> initialValue [
	^#()
]

{ #category : 'running' }
MiButtonEditablelistSettingItemTest >> settingItemInstance [
	^MiButtonEditablelistSettingItem new
]

{ #category : 'running' }
MiButtonEditablelistSettingItemTest >> someOtherValue [
	^#( a 2 )
]
