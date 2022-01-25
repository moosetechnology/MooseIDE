"
An abstract class to regroup all notebook pages of the TagBrowser
"
Class {
	#name : #MiAbstractTagNotebookPage,
	#superclass : #MiPresenter,
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #'as yet unclassified' }
MiAbstractTagNotebookPage class >> disabledTitle [ 
	^'----------'
]
