Class {
	#name : #MiAbstractSettingsManager,
	#superclass : #Object,
	#instVars : [
		'specModel',
		'settingsBuilders'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #'instance creation' }
MiAbstractSettingsManager class >> on: aSpecModel [

	^ self new
		  specModel: aSpecModel;
		  yourself 
]

{ #category : #initialization }
MiAbstractSettingsManager >> initialize [

	super initialize.
	settingsBuilders := OrderedCollection new.
	self initializeSettingsBuilders
]

{ #category : #initialization }
MiAbstractSettingsManager >> initializeSettingsBuilders [

	self subclassResponsibility
]

{ #category : #ui }
MiAbstractSettingsManager >> openSettings [

	(MiSettingsPresenter on: self) openModal
]

{ #category : #accessing }
MiAbstractSettingsManager >> settingsBuilders [

	^ settingsBuilders
]

{ #category : #accessing }
MiAbstractSettingsManager >> specModel: aSpecModel [

	specModel := aSpecModel
]

{ #category : #ui }
MiAbstractSettingsManager >> title [

	^ specModel toolName , ' settings'
]
