Class {
	#name : #MiSettingCommand,
	#superclass : #CmCommand,
	#instVars : [
		'presenterClass',
		'label',
		'help',
		'action',
		'initialValue'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiSettingCommand class >> application [

	^ MiApplication current
]

{ #category : #default }
MiSettingCommand class >> defaultAction [
	"Override to set an action"

	^ [ self inform: 'This setting does nothing' ]
]

{ #category : #default }
MiSettingCommand class >> defaultDescription [
	"Override to set a default description"

	^ 'This setting is not documented'
]

{ #category : #default }
MiSettingCommand class >> defaultName [
	"Override to set a default name"

	^ 'This setting has no name'
]

{ #category : #testing }
MiSettingCommand class >> isAbstract [

	^ self = MiSettingCommand
]

{ #category : #specs }
MiSettingCommand class >> presenterClass [

	self subclassResponsibility
]

{ #category : #accessing }
MiSettingCommand >> action [

	^ action ifNil: [ self class defaultAction ]
]

{ #category : #accessing }
MiSettingCommand >> action: aValuable [

	action := aValuable
]

{ #category : #accessing }
MiSettingCommand >> application [

	^ self class application
]

{ #category : #building }
MiSettingCommand >> buildPresenter [

	^ (self presenterClass on: self)
		  help: self description;
		  yourself
]

{ #category : #accessing }
MiSettingCommand >> currentValue [

	^ self subclassResponsibility
]

{ #category : #execution }
MiSettingCommand >> execute: aSpecValue [

	self action cull: aSpecValue cull: self context
]

{ #category : #accessing }
MiSettingCommand >> presenterClass [

	^ self class presenterClass
]
