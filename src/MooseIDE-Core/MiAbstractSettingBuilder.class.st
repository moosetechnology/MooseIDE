Class {
	#name : #MiAbstractSettingBuilder,
	#superclass : #Object,
	#instVars : [
		'presenterClass',
		'label',
		'help',
		'action',
		'manager'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #'as yet unclassified' }
MiAbstractSettingBuilder class >> defaultPresenterClass [

	self subclassResponsibility
]

{ #category : #testing }
MiAbstractSettingBuilder class >> isAbstract [

	^ self = MiAbstractSettingBuilder
]

{ #category : #'instance creation' }
MiAbstractSettingBuilder class >> on: aMiSettingsManager [

	^ self new
		  manager: aMiSettingsManager;
		  yourself
]

{ #category : #accessing }
MiAbstractSettingBuilder >> action [

	^ action ifNil: [ self defaultAction ]
]

{ #category : #accessing }
MiAbstractSettingBuilder >> action: aValuable [

	action := aValuable
]

{ #category : #building }
MiAbstractSettingBuilder >> buildPresenterIn: aMiSettingsPresenter [

	| presenter |
	presenter := self initializePresenter owner: aMiSettingsPresenter.

	aMiSettingsPresenter layoutBuilder
		add: self label;
		add: presenter;
		nextRow
]

{ #category : #default }
MiAbstractSettingBuilder >> defaultAction [
	"Override to set an action"

	^ [ self inform: 'This setting does nothing' ]
]

{ #category : #default }
MiAbstractSettingBuilder >> defaultHelp [
	"Override to set a default help text"

	^ 'This setting has not be documented'
]

{ #category : #default }
MiAbstractSettingBuilder >> defaultLabel [
	"Override to set a default label"

	^ 'This setting has not be named'
]

{ #category : #accessing }
MiAbstractSettingBuilder >> help [

	^ help ifNil: [ self defaultHelp ]
]

{ #category : #accessing }
MiAbstractSettingBuilder >> help: aHelpText [

	help := aHelpText
]

{ #category : #building }
MiAbstractSettingBuilder >> initializePresenter [

	^ self presenterClass new
		  help: self help;
		  yourself
]

{ #category : #accessing }
MiAbstractSettingBuilder >> label [

	^ label ifNil: [ self defaultLabel ]
]

{ #category : #accessing }
MiAbstractSettingBuilder >> label: aLabel [

	label := aLabel
]

{ #category : #accessing }
MiAbstractSettingBuilder >> manager [

	^ manager
]

{ #category : #accessing }
MiAbstractSettingBuilder >> manager: aMiSettingsManager [

	manager := aMiSettingsManager
]

{ #category : #accessing }
MiAbstractSettingBuilder >> presenterClass [

	^ presenterClass ifNil: [
		  presenterClass := self class defaultPresenterClass ]
]
