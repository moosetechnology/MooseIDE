Class {
	#name : #MiTagCategoriesPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'categoryDropList'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagCategoriesPresenter >> initializePresenters [

	categoryDropList := self newDropList.
	
]
