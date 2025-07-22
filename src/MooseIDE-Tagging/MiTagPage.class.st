"
An abstract class for the right part of the TagBrowser. It allows to define the content of a tag
"
Class {
	#name : 'MiTagPage',
	#superclass : 'MiPresenter',
	#instVars : [
		'tagDescription'
	],
	#category : 'MooseIDE-Tagging-Browser',
	#package : 'MooseIDE-Tagging',
	#tag : 'Browser'
}

{ #category : 'initialization' }
MiTagPage >> deleteCurrentTag [

	self owner deleteCurrentTag
]

{ #category : 'action' }
MiTagPage >> editCurrentTag [

	self owner editCurrentTag
]

{ #category : 'initialization' }
MiTagPage >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: tagDescription expand: false;
			 yourself)
]

{ #category : 'initialization' }
MiTagPage >> initializePresenters [
	
	tagDescription := self instantiate: MiTagDescription on: self model
]

{ #category : 'accessing' }
MiTagPage >> model [
	^owner model
]

{ #category : 'refreshing' }
MiTagPage >> refresh [

	self refreshTagDescription
]

{ #category : 'accessing' }
MiTagPage >> refreshTagDescription [

	tagDescription refresh
]

{ #category : 'accessing' }
MiTagPage >> setTag: aTag [

	tagDescription setTag: aTag.
]
