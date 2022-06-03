Class {
	#name : #MiButtonEditablelistSettingItemTest,
	#superclass : #MiAbstractSettingItemTest,
	#category : #'MooseIDE-Tests-Settings'
}

{ #category : #running }
MiButtonEditablelistSettingItemTest >> initialValue [
	^#()
]

{ #category : #running }
MiButtonEditablelistSettingItemTest >> settingItemInstance [
	^MiButtonEditablelistSettingItem new
]

{ #category : #running }
MiButtonEditablelistSettingItemTest >> someOtherValue [
	^#( a 2 )
]
