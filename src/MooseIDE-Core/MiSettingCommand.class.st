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

{ #category : #default }
MiSettingCommand class >> defaultAction [
	"Override to set an action"

	^ [ self inform: 'This setting does nothing' ]
]

{ #category : #default }
MiSettingCommand class >> defaultCurrentValue [
	"Override to set a way to get the current value, 
	i.e. get it from the settings manager"

	^ nil
]

{ #category : #default }
MiSettingCommand class >> defaultDescription [
	"Override to set a default description"

	^ 'This setting is not documented'
]

{ #category : #default }
MiSettingCommand class >> defaultInitialValue [
	"Override to set the default initial state/selected item/value"

	^ nil
]

{ #category : #default }
MiSettingCommand class >> defaultName [
	"Override to set a default name"

	^ 'This setting has no name'
]

{ #category : #'as yet unclassified' }
MiSettingCommand class >> defaultPresenterClass [

	self subclassResponsibility
]

{ #category : #testing }
MiSettingCommand class >> isAbstract [

	^ self = MiSettingCommand
]

{ #category : #accessing }
MiSettingCommand >> action [

	^ action ifNil: [ self class defaultAction ]
]

{ #category : #accessing }
MiSettingCommand >> action: aValuable [

	action := aValuable
]

{ #category : #building }
MiSettingCommand >> buildPresenter [

	^ self presenterClass new
		  help: self description;
		  yourself
]

{ #category : #accessing }
MiSettingCommand >> currentValue [

	^ self subclassResponsibility
]

{ #category : #execution }
MiSettingCommand >> execute: aSpecValue [

	self subclassResponsibility
]

{ #category : #accessing }
MiSettingCommand >> presenterClass [

	^ presenterClass ifNil: [
		  presenterClass := self class defaultPresenterClass ]
]
