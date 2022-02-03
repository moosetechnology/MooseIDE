Class {
	#name : #MiTagDescription,
	#superclass : #MiPresenter,
	#instVars : [
		'tagFormPresenter',
		'tagNameLabel',
		'tagDescriptionText',
		'tagDescriptionButton',
		'tagModel'
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
					  spacing: 5;
					  add: tagFormPresenter expand: false;
					  add: tagNameLabel expand: false;
					  add: (SpBoxLayout newLeftToRight hAlignEnd
							   add: tagDescriptionButton
							   expand: false);
					  yourself)
			 expand: false;
			 add: sep height: 2;
			 yourself)
]

{ #category : #initialization }
MiTagDescription >> initializePresenters [

	tagNameLabel := self newLabel.
	tagDescriptionText := self newText beNotEditable.
	tagDescriptionButton := self newToolbar
		                        beIcons;
		                        addItem: (self newToolbarPopoverButton
				                         content: (SpPresenter new
						                          layout: (SpBoxLayout newLeftToRight
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
				                         icon: (self iconNamed: #smallCogState3);
				                         help: 'Edit tag';
				                         action: [ self owner editCurrentTag ];
				                         yourself);
		                        addItem: (self newToolbarButton
				                         icon: (self iconNamed: #delete);
				                         help: 'Delete Tag';
				                         action: [ self owner deleteCurrentTag ];
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
	tagFormPresenter image: (tagModel iconForTag: aTag).
	self update
]
