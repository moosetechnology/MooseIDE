"
A MiSettingItem subclass for tests.
It stores the value in an instance variable and the presenter is a Mock
"
Class {
	#name : 'MiStubSettingItem',
	#superclass : 'MiAbstractSettingItem',
	#instVars : [
		'value'
	],
	#category : 'MooseIDE-Tests-Settings',
	#package : 'MooseIDE-Tests',
	#tag : 'Settings'
}

{ #category : 'tests' }
MiStubSettingItem >> getValue [
	^value
]

{ #category : 'initialization' }
MiStubSettingItem >> initialize [ 
	super initialize.
	
	presenter := Mock named: 'presenter'
]

{ #category : 'tests' }
MiStubSettingItem >> setValue: anObject [
	value := anObject
]
