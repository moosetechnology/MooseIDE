Class {
	#name : #MiEditBusCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #initialization }
MiEditBusCommand class >> defaultDescription [

	^ 'Edit buses'
]

{ #category : #initialization }
MiEditBusCommand class >> defaultIconName [

	^ #mooseEditor
]

{ #category : #converting }
MiEditBusCommand >> asSpecCommand [

	| specCommand |
	specCommand := super asSpecCommand
		               name: 'Buses';
		               yourself.

	specCommand buildPresenterBlock: [ :cmd | 
		SpToolbarPopoverButtonPresenter new
			label: specCommand name;
			help: specCommand description;
			icon: specCommand icon;
			content: [ self busesList ];
			yourself ].

	^ specCommand
]

{ #category : #converting }
MiEditBusCommand >> busesList [

	| busesList |
	busesList := SpFilteringSelectableListPresenter new.
	busesList layout: (SpBoxLayout newTopToBottom
			 add: SpFilteringSelectableListPresenter defaultSpec
			 withConstraints: [ :c | 
				 c
					 height: 125;
					 width: 150 ];
			 yourself).
	busesList display: [ :bus | bus name ].
	busesList items: self application buses.
	busesList selectItems: context buses.

	busesList
		onActivation: [ :bus | bus ifNotNil: [ context followBus: bus ] ];
		onDeactivation: [ :bus | bus ifNotNil: [ context unfollowBus: bus ] ].

	"Do not filter bus use text input for bus creation"
	busesList filterInputPresenter placeholder: '+ New bus'.
	busesList itemFilter: [ :each :pattern | 
		true "We do not want to filter anything" ].
	busesList filterInputPresenter whenSubmitDo: [ 
		context followBus:
			(self application busNamed: busesList filterInputPresenter text).
		busesList filterInputPresenter clearContent.
		busesList items: self application buses ].
	^ busesList
]

{ #category : #execution }
MiEditBusCommand >> execute [

	
]
