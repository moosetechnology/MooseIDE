Class {
	#name : #MiPresenter,
	#superclass : #SpPresenter,
	#category : #'Midas-Core-Browser'
}

{ #category : #private }
MiPresenter class >> currentApplication [
	^ MiApplication default
]

{ #category : #private }
MiPresenter class >> new [
	self flag: #Todo."With the next version of spec this will not be needed as it will just take the current application"
	^ self newApplication: self currentApplication
]

{ #category : #private }
MiPresenter class >> on: anObject [
	self flag: #Todo.	"With the next version of spec this will not be needed as it will just take the current application"
	^ self newApplication: self currentApplication model: anObject
]

{ #category : #private }
MiPresenter class >> owner: anOwningPresenter [
	self flag: #Todo.	"With the next version of spec this will not be needed as it will just take the current application"
	^ self newApplication: self currentApplication owner: anOwningPresenter
]

{ #category : #private }
MiPresenter class >> owner: anOwningPresenter on: aDomainObject [
	self flag: #Todo.	"With the next version of spec this will not be needed as it will just take the current application"
	^ self
		newApplication: self currentApplication
		owner: anOwningPresenter
		model: aDomainObject
]

{ #category : #testing }
MiPresenter >> isMiBrowser [
	^ false
]
