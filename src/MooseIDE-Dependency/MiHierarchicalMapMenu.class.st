Class {
	#name : #MiHierarchicalMapMenu,
	#superclass : #MiPresenter,
	#instVars : [
		'currentModelPresenter',
		'currentGroupPresenter',
		'submitButton',
		'propertyListPresenter',
		'elementsCodePresenter',
		'addTagButton'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #initialization }
MiHierarchicalMapMenu >> initializePresenters [

	super initializePresenters.
	submitButton := self newButton
		                label: 'Draw';
		                action: [ 
			                | ow |
			                ow := self owner.
			                ow layout remove: self.
			                ow visualization run ];
		                yourself.
	currentGroupPresenter := self newButton
		                         disable;
		                         label: 'None';
		                         yourself.
	currentModelPresenter := self newButton
		                         disable;
		                         label: 'None';
		                         yourself.
	elementsCodePresenter := self newCode
		                         withoutLineNumbers;
		                         text: '[ :container | container children ]'.
	addTagButton := self newButton icon: (self iconNamed: #smallAdd).
	propertyListPresenter := self newComponentList.
	self layout: (SpBoxLayout newTopToBottom
			 add: currentModelPresenter expand: false;
			 add: currentGroupPresenter expand: false;
			 add: (self newLabel label: 'Children block:') expand: false;
			 add: elementsCodePresenter;
			 add: (SpBoxLayout newLeftToRight
					  vAlignCenter;
					  add: 'Properties:' asPresenter expand: false;
					  add: addTagButton width: self class iconWidth)
			 expand: false;
			 add: propertyListPresenter;
			 add: submitButton expand: false;
			 yourself)
]

{ #category : #initialization }
MiHierarchicalMapMenu >> updatePresenter [

	self owner model entities ifNil: [ ^ self ].
	currentGroupPresenter
		label: (String streamContents: [ :s | 
					 self owner model entities displayStringOn: s ]);
		icon: self owner model entities mooseIcon.
	currentModelPresenter
		label: self owner model entities mooseModel mooseName;
		icon: self owner model entities mooseModel mooseIcon
]
