Class {
	#name : #MiTagListPresenter,
	#superclass : #SpEditableListPresenter,
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #specs }
MiTagListPresenter class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  add: #addButton expand: false;
		  add: #list;
		  yourself
]
