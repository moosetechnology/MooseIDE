Class {
	#name : #MiAbstractSettingItemTest,
	#superclass : #TestCase,
	#instVars : [
		'settingItem'
	],
	#category : #'MooseIDE-Tests-Settings'
}

{ #category : #testing }
MiAbstractSettingItemTest class >> isAbstract [
	^ self == MiAbstractSettingItemTest
]

{ #category : #running }
MiAbstractSettingItemTest >> initialValue [
	self subclassResponsibility 
]

{ #category : #running }
MiAbstractSettingItemTest >> setUp [
	super setUp.
	
	settingItem := self settingItemInstance.
	settingItem setValue: self initialValue  
]

{ #category : #running }
MiAbstractSettingItemTest >> settingItemInstance [
	self subclassResponsibility 
]

{ #category : #running }
MiAbstractSettingItemTest >> someOtherValue [
	self subclassResponsibility 
]

{ #category : #tests }
MiAbstractSettingItemTest >> testBuildLayout [
	| layout |
	settingItem label: 'Setting label'.
	layout := settingItem buildLayout.

	self assert: layout class equals: SpBoxLayout.
	self assert: layout direction class equals: SpHorizontalLayoutDirection.
	self assert: layout children size equals: 2.
	self assert: layout children first label equals: 'Setting label'
]

{ #category : #tests }
MiAbstractSettingItemTest >> testConfirmValue [
	settingItem label: 'Setting label'.
	settingItem buildLayout.
	
	settingItem setValue: self someOtherValue.
	self assert: settingItem getValue equals: self someOtherValue.
	
	settingItem resetValue.
	self assert: settingItem getValue equals: self initialValue .
]

{ #category : #tests }
MiAbstractSettingItemTest >> testGetValue [
	self assert: settingItem getValue equals: self initialValue
]

{ #category : #tests }
MiAbstractSettingItemTest >> testHelp [
	settingItem help: 'Setting help'.

	self assert: settingItem help equals: 'Setting help'.
]

{ #category : #tests }
MiAbstractSettingItemTest >> testLabel [
	settingItem label: 'Setting label'.

	self assert: settingItem label equals: 'Setting label'.
]

{ #category : #tests }
MiAbstractSettingItemTest >> testResetValue [
	settingItem label: 'Setting label'.
	settingItem buildLayout.
	
	settingItem setValue: self someOtherValue.
	self assert: settingItem getValue equals: self someOtherValue.
	
	settingItem resetValue.
	self assert: settingItem getValue equals: self initialValue.
]

{ #category : #tests }
MiAbstractSettingItemTest >> testSetValue [
	settingItem setValue: self someOtherValue.

	self assert: settingItem getValue equals: self someOtherValue
]
