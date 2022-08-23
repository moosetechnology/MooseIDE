Class {
	#name : #SpColorDropdownList,
	#superclass : #SpPresenter,
	#instVars : [
		'colorList',
		'selectedColor',
		'whenColorAccepted',
		'window',
		'ok',
		'cancel',
		'setNil'
	],
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #specs }
SpColorDropdownList class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: #colorList;
				   yourself)
		  height: 70
]

{ #category : #specs }
SpColorDropdownList class >> open [ 
	<script> 
	^ self new open
]

{ #category : #actions }
SpColorDropdownList >> acceptColor [

	whenColorAccepted ifNotNil: [ 
		whenColorAccepted value: colorList selectedItem color ].
	window ifNotNil: [ window close  ]
]

{ #category : #actions }
SpColorDropdownList >> cancelColor [
	window close. 
]

{ #category : #actions }
SpColorDropdownList >> initializePresenters [

	super initializePresenters.


	colorList := self newDropList.

	colorList
		display: [ :m | m color name capitalized ];
		displayIcon: [ :e | e asForm ];
		items:
			((Color colors reject: [ :i | i name = 'unnamed' ]) collect: [ :c | 
					 Morph new
						 color: c;
						 yourself ]).
	colorList
]

{ #category : #actions }
SpColorDropdownList >> selectedColor [

	^ colorList selectedItem color
]

{ #category : #actions }
SpColorDropdownList >> selectedColor: aColor [

	colorList items
		detect: [ :c | c color = aColor ]
		ifFound: [ :m | colorList selectItem: m ]
]

{ #category : #actions }
SpColorDropdownList >> whenColorAccepted: aBlock [ 
	whenColorAccepted := aBlock
]
