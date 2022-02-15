Class {
	#name : #MiTagDescription,
	#superclass : #MiPresenter,
	#instVars : [
		'tagFormPresenter',
		'tagNameLabel',
		'tagDescriptionText',
		'tagDescriptionButton',
		'tagModel',
		'tagMenu'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagDescription >> initializeLayout [

	| sep |
	(sep := SpRoassalPresenter new) canvas color: (Color
			 r: 80
			 g: 80
			 b: 80
			 range: 255) translucent.
	self layout: (SpBoxLayout newTopToBottom
			 spacing: 1;
			 add: (SpBoxLayout newLeftToRight
					  vAlignCenter;
					hAlignStart;
					  add: (SpBoxLayout newLeftToRight
							   hAlignStart;
							   add: tagDescriptionButton expand: false;
							   yourself);
					  spacing: 5;
					  add: tagFormPresenter expand: false;
					  add: tagNameLabel;
					  yourself)
			 expand: false;
			 add: sep height: 2;
			 yourself)
]

{ #category : #initialization }
MiTagDescription >> initializePresenters [

	tagNameLabel := self newLabel.
	tagDescriptionText := self newText beNotEditable.
	tagMenu := self newMenu.
	tagMenu addItem: [ :item | 
		item
			name: 'Edit tag';
			icon: (self iconNamed: #edit);
			action: [ self owner editCurrentTag ] ].
	tagMenu addItem: [ :item | 
		item
			name: 'Delete tag';
			icon: (self iconNamed: #glamorousClose);
			action: [ self owner deleteCurrentTag ] ].
	tagDescriptionButton := self newToolbar
		                        beIcons;
		                        addItem: (self newToolbarPopoverButton
				                         content: (SpPresenter new
						                          layout: (SpBoxLayout newTopToBottom
								                           add: 'Description:' asPresenter
								                           expand: false;
								                           add: tagDescriptionText
								                           withConstraints: [ :const | 
									                           const
										                           width: 300;
										                           height: 200 ]);
						                          yourself);
				                         help: 'Tag desciption';
				                         icon: (self iconNamed: #help);
				                         yourself);
		                        addItem: (self newToolbarButton
				                         help: 'Tag menu';
				                         icon: (self iconNamed: #arrowDown);
				                         action: [ 
					                         tagMenu openWithSpecAt:
							                         self currentHand position ];
				                         yourself);
		                        yourself.
	tagFormPresenter := self newImage.
	self initializeLayout
]

{ #category : #initialization }
MiTagDescription >> refresh [

	self setTag: tagModel currentTag
]

{ #category : #initialization }
MiTagDescription >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : #initialization }
MiTagDescription >> setTag: aTag [

	aTag ifNil: [ ^self ].
	tagNameLabel label: aTag name.
	tagDescriptionText text: (aTag description
			 ifNotNil: [ :text | text ]
			 ifNil: [ 'No description on this tag.' ]).
	tagFormPresenter image: (tagModel class iconForTag: aTag).
	self update
]
