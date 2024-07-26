"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #MiAbstractMetaGroupNavigationBrowser,
	#superclass : #MiMetaNavigationBrowser,
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #initialization }
MiAbstractMetaGroupNavigationBrowser >> initializePresenters [

	super initializePresenters.
	navigation whenActivatedDo: [ :selection |
		self inspectorObjectContextPresenter owner
			changeSelection: selection selectedItem value
			from: self inspectorObjectContextPresenter ].
	entitiesColumn evaluated: [ :el | el key ]
]

{ #category : #initialization }
MiAbstractMetaGroupNavigationBrowser >> itemsFor: anEntity [

	^ anEntity collect: [ :entity | entity inspectorToString -> entity ]
]
