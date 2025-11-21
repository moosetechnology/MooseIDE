Class {
	#name : 'MiPresenter',
	#superclass : 'SpPresenter',
	#category : 'MooseIDE-Core-Browser',
	#package : 'MooseIDE-Core',
	#tag : 'Browser'
}

{ #category : 'accessing' }
MiPresenter class >> currentApplication [

	^ MiApplication current
]

{ #category : 'accessing' }
MiPresenter class >> iconNamed: aName [

	^ self currentApplication iconNamed: aName
]

{ #category : 'instance creation' }
MiPresenter class >> new [

	^ self newApplication: self currentApplication
]

{ #category : 'specs' }
MiPresenter class >> tableLineHeight [
	^ self labelHeight + 5
]

{ #category : 'actions' }
MiPresenter >> helpText [
	"Override when necessary"

	^ self class comment
]

{ #category : 'testing' }
MiPresenter >> isMiBrowser [
	^ false
]

{ #category : 'scripting - widgets' }
MiPresenter >> newMooseGroupsTreeTable [

	^ self instantiate: MiMooseGroupsTreeTablePresenter
]

{ #category : 'accessing' }
MiPresenter >> rootBrowser [

	^ self isMiBrowser
		  ifTrue: [ self ]
		  ifFalse: [ self owner rootBrowser ]
]

{ #category : 'accessing' }
MiPresenter >> windowIcon [

	^ self iconNamed: #mooseIcon
]
