Class {
	#name : 'MiColorSettingItemTest',
	#superclass : 'MiAbstractSettingItemTest',
	#category : 'MooseIDE-Tests-Settings',
	#package : 'MooseIDE-Tests',
	#tag : 'Settings'
}

{ #category : 'running' }
MiColorSettingItemTest >> initialValue [
	
	^ Color black
]

{ #category : 'running' }
MiColorSettingItemTest >> settingItemInstance [

	^ MiColorSettingItem new
]

{ #category : 'running' }
MiColorSettingItemTest >> someOtherValue [
	
	^ Color white
]
