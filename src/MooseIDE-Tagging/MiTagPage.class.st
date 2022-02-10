Class {
	#name : #MiTagPage,
	#superclass : #MiPresenter,
	#instVars : [
		'tagDescription',
		'tagModel'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagPage >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: tagDescription expand: false;
			 yourself)
]

{ #category : #initialization }
MiTagPage >> initializePresenters [
	
	tagDescription := self instantiate: MiTagDescription on: tagModel
]

{ #category : #accessing }
MiTagPage >> refresh [

	self subclassResponsibility
]

{ #category : #accessing }
MiTagPage >> refreshTagDescription [

	tagDescription refresh
]

{ #category : #initialization }
MiTagPage >> setModelBeforeInitialization: aModel [

	tagModel := aModel
]
