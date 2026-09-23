"
An abstract class for the right part of the TagBrowser. It allows to define the content of a tag
"
Class {
	#name : #MiTagPage,
	#superclass : #MiPresenter,
	#instVars : [
		'tagDescription'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagPage >> deleteCurrentTag [

	self owner deleteCurrentTag
]

{ #category : #action }
MiTagPage >> editCurrentTag [

	self owner editCurrentTag
]

{ #category : #initialization }
MiTagPage >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: tagDescription expand: false;
			 yourself)
]

{ #category : #initialization }
MiTagPage >> initializePresenters [

	tagDescription := self
		                  instantiate: MiTagDescription
		                  on: self specModel
]

{ #category : #accessing }
MiTagPage >> model [
	self
		deprecated: 'This is a getter. Lets name it correctly.'
		transformWith: '`@receiver model' -> '`@receiver specModel'.
	^ self specModel
]

{ #category : #refreshing }
MiTagPage >> refresh [

	self refreshTagDescription
]

{ #category : #accessing }
MiTagPage >> refreshTagDescription [

	tagDescription refresh
]

{ #category : #accessing }
MiTagPage >> setTag: aTag [

	tagDescription setTag: aTag.
]

{ #category : #accessing }
MiTagPage >> specModel [

	^ owner specModel
]
