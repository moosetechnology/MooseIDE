"
Use me to tag selected entities. One can also choose what tag to use
"
Class {
	#name : #MiTagCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #'accessing - defaults' }
MiTagCommand class >> defaultDescription [

	^ 'Tag selected entities with current tag'
]

{ #category : #'accessing - defaults' }
MiTagCommand class >> defaultName [
	^ 'Tag entities'
]

{ #category : #converting }
MiTagCommand >> asSpecCommand [

	| specCommand |
	specCommand := super asSpecCommand
		name: 'Tag';
		description: self help;
		yourself.

	specCommand buildPresenterBlock: [ :cmd | 
		SpToolbarPopoverButtonPresenter new
			label: specCommand decoratedCommand label;
			help: specCommand decoratedCommand help;
			icon: (self iconProvider iconForTag: context lastTagSelected);
			content: [ self tagsList ];
			yourself ].

	^ specCommand
]

{ #category : #testing }
MiTagCommand >> canBeExecuted [

	^ self context canTagEntities
]

{ #category : #testing }
MiTagCommand >> execute [

	context tagSelectedEntities
]

{ #category : #accessing }
MiTagCommand >> help [
	self canBeExecuted ifFalse: [ ^'no tagging' ].

	^ String streamContents: [ :s | 
		  self context tagList do: [ :tag | 
			  s
				  << '- ';
				  << tag name;
				  cr ].
		  s << 'Click to edit' ]
]

{ #category : #accessing }
MiTagCommand >> label [
	^context tagName
]

{ #category : #accessing }
MiTagCommand >> tagsList [

	| tagsList |
	tagsList := SpFilteringListPresenter new.
	tagsList layout: (SpBoxLayout newTopToBottom
			 add: SpFilteringListPresenter defaultLayout
			 withConstraints: [ :c | 
				 c
					 height: 120;
					 width: 120 ];
			 yourself).
	tagsList display: [ :tag | tag name ].
	tagsList items: context tagList.

	"Do not filter tags use text input for tag creation"
	tagsList filterInputPresenter placeholder: '+ New tag'.
	tagsList itemFilter: [ :each :pattern | 
		true "We do not want to filter anything" ].
    
	"tagsList filterInputPresenter whenSubmitDo: [ :busName |
		context followBus:
			(self application busNamed: busName).
		tagsList filterInputPresenter clearContent.
		tagsList items: self application buses.
		tagsList selectItems: context buses copy ]."
	^ tagsList
]
