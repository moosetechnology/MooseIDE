Class {
	#name : #MiAbstractSettingPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'label',
		'help',
		'configuration'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiAbstractSettingPresenter class >> help [

	^ ''
]

{ #category : #accessing }
MiAbstractSettingPresenter class >> label [

	^ ''
]

{ #category : #accessing }
MiAbstractSettingPresenter >> help [

	^ help ifNil: [ self class help ]
]

{ #category : #accessing }
MiAbstractSettingPresenter >> help: aString [

	help := aString
]

{ #category : #accessing }
MiAbstractSettingPresenter >> label [

	^ label ifNil: [ self class label ]
]

{ #category : #accessing }
MiAbstractSettingPresenter >> label: aString [

	label := aString
]

{ #category : #accessing }
MiAbstractSettingPresenter >> labelPresenter [

	^ self label asPresenter
		  help: self help;
		  yourself
]

{ #category : #'accessing - model' }
MiAbstractSettingPresenter >> setModelBeforeInitialization: aMemento [

	configuration := aMemento
]
