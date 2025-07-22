Class {
	#name : 'MiButtonSelectableListSettingItemTest',
	#superclass : 'MiAbstractSettingItemTest',
	#category : 'MooseIDE-Tests-Settings',
	#package : 'MooseIDE-Tests',
	#tag : 'Settings'
}

{ #category : 'running' }
MiButtonSelectableListSettingItemTest >> initialValue [

	^OrderedCollection with: 1
]

{ #category : 'running' }
MiButtonSelectableListSettingItemTest >> settingItemInstance [
	
	^ MiButtonSelectableListSettingItem new
]

{ #category : 'running' }
MiButtonSelectableListSettingItemTest >> someOtherValue [
	
	^OrderedCollection with: 3 with: 2 with: 1
]
