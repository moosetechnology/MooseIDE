Class {
	#name : 'MiDroplistSettingItemTest',
	#superclass : 'MiAbstractSettingItemTest',
	#category : 'MooseIDE-Tests-Settings',
	#package : 'MooseIDE-Tests',
	#tag : 'Settings'
}

{ #category : 'running' }
MiDroplistSettingItemTest >> initialValue [
	^'one'
]

{ #category : 'running' }
MiDroplistSettingItemTest >> settingItemInstance [
	^MiDroplistSettingItem new
		possibleValues: #('one' 'deux' 'tres') ;
		yourself
]

{ #category : 'running' }
MiDroplistSettingItemTest >> someOtherValue [
	^'deux'
]

{ #category : 'tests' }
MiDroplistSettingItemTest >> testSelectOtherValue [
	settingItem presenter selectIndex: 3.
	self assert: settingItem getValue equals: 'tres'
]
