Class {
	#name : #MiTagListPresenter,
	#superclass : #SpEditableListPresenter,
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #layout }
MiTagListPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #addButton expand: false;
		  add: #list;
		  yourself
]
