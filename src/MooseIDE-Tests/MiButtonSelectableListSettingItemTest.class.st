Class {
	#name : #MiButtonSelectableListSettingItemTest,
	#superclass : #MiAbstractSettingItemTest,
	#category : #'MooseIDE-Tests-Settings'
}

{ #category : #running }
MiButtonSelectableListSettingItemTest >> initialValue [

	^ { 1 } asOrderedCollection
]

{ #category : #running }
MiButtonSelectableListSettingItemTest >> settingItemInstance [
	
	^ MiButtonSelectableListSettingItem new
]

{ #category : #running }
MiButtonSelectableListSettingItemTest >> someOtherValue [
	
	^ { 3. 2. 1 } asOrderedCollection
]
