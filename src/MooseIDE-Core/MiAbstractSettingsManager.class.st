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

{ #category : #ui }
MiAbstractSettingsManager >> openSettings [

	^ (MiSettingsPresenter on: self) openDialog
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
