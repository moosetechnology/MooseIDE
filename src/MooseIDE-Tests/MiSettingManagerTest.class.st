Class {
	#name : #MiSettingManagerTest,
	#superclass : #TestCase,
	#instVars : [
		'settingManager'
	],
	#category : #'MooseIDE-Tests-Settings'
}

{ #category : #running }
MiSettingManagerTest >> setUp [ 
	super setUp.

	settingManager := MiSettingsPresenter new.
	
]

{ #category : #tests }
MiSettingManagerTest >> testAddItemNamed [
	| settingItem |
	self assertEmpty: settingManager settingItems.
	
	settingItem := MiStubSettingItem new.
	settingManager addItem: settingItem named: #stub.
	self assert: settingManager settingItems size equals: 1.
	self assert: (settingManager settingItems at: #stub) equals: settingItem 

]

{ #category : #tests }
MiSettingManagerTest >> testConfirmItems [
	| settingItem |
	settingItem := MiStubSettingItem new.
	settingItem setValue: 'one'.
	settingManager addItem: settingItem named: #stub.
	settingManager buildPresenter.

	self assert: (settingManager getItemValue: #stub) equals: 'one'.
	
	settingItem setValue: 'two'.
	self assert: (settingManager getItemValue: #stub) equals: 'two'.

	settingManager confirmItems.
	self assert: (settingManager getItemValue: #stub) equals: 'two'.

]

{ #category : #tests }
MiSettingManagerTest >> testGetItemValue [
	| settingItem |
	settingItem := MiStubSettingItem new.
	settingItem setValue: 'one'.
	settingManager addItem: settingItem named: #stub.
	
	self assert: (settingManager getItemValue: #stub) equals: 'one'.

	settingItem setValue: 'two'.
	self assert: (settingManager getItemValue: #stub) equals: 'two'.

]

{ #category : #tests }
MiSettingManagerTest >> testResetItems [
	| settingItem |
	settingItem := MiStubSettingItem new.
	settingItem setValue: 'one'.
	settingManager addItem: settingItem named: #stub.
	settingManager buildPresenter.

	self assert: (settingManager getItemValue: #stub) equals: 'one'.
	
	settingItem setValue: 'two'.
	self assert: (settingManager getItemValue: #stub) equals: 'two'.

	settingManager resetItems.
	self assert: (settingManager getItemValue: #stub) equals: 'one'.

]

{ #category : #tests }
MiSettingManagerTest >> testSetItemValue [
	| settingItem |
	settingItem := MiStubSettingItem new.
	settingItem setValue: 'one'.
	settingManager addItem: settingItem named: #stub.
	
	self assert: settingItem getValue equals: 'one'.

	settingManager setItem: #stub value: 'two'.
	self assert: settingItem getValue equals: 'two'.

]
