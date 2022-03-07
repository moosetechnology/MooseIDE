Class {
	#name : #MiSourceExtension,
	#superclass : #SpPresenter,
	#instVars : [
		'properties',
		'model',
		'sourceText'
	],
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #layout }
MiSourceExtension class >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #sourceText;
		  yourself
]

{ #category : #initialization }
MiSourceExtension >> initializePresenters [

	sourceText := self newCode
		withoutSyntaxHighlight;
		withLineNumbers;
		text: model sourceText;
		beNotEditable
]

{ #category : #initialization }
MiSourceExtension >> model [
	^ model
]

{ #category : #initialization }
MiSourceExtension >> model: anObject [
	model := anObject.
	sourceText ifNotNil: [sourceText text: model sourceText]
]

{ #category : #initialization }
MiSourceExtension >> setModelBeforeInitialization: aModel [
	self model: aModel
]
