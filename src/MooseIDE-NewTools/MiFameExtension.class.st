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

    Instance Variables
	model:		<Object>
	properties:		<Object>


    Implementation Points
"
Class {
	#name : #MiFameExtension,
	#superclass : #SpPresenter,
	#instVars : [
		'model',
		'fameDescription'
	],
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #specs }
MiFameExtension class >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #fameDescription;
		  yourself
]

{ #category : #initialization }
MiFameExtension >> initializePresenters [
	fameDescription := self newTable.
	fameDescription
		items: (self model mooseDescription allComplexProperties sorted: #name ascending);
		addColumn: (SpStringTableColumn title: 'Name' evaluated: [ :item | item name ]) yourself;
		addColumn: (SpStringTableColumn title: 'Type' evaluated: [ :item | item type name ]) yourself;
		addColumn: (SpStringTableColumn title: 'Opposite' evaluated: [ :item | item opposite ifNil: [ '' ] ifNotNil: [ :opposite | opposite name ] ]) yourself;
		addColumn: (SpStringTableColumn title: 'Derived?' evaluated: [ :item | item isDerived ]) yourself;
		addColumn: (SpStringTableColumn title: 'Container?' evaluated: [ :item | item isContainer ]) yourself;
		addColumn: (SpStringTableColumn title: 'IsTarget?' evaluated: [ :item | item isTarget ]) yourself;
		addColumn: (SpStringTableColumn title: 'IsSource?' evaluated: [ :item | item isSource ]) yourself;
		beResizable
]

{ #category : #accessing }
MiFameExtension >> model [
	^ model
]

{ #category : #accessing }
MiFameExtension >> model: anObject [
	model := anObject.
	fameDescription ifNotNil: [ :fd | fd items: model mooseDescription allComplexProperties ]
]

{ #category : #'accessing - model' }
MiFameExtension >> setModelBeforeInitialization: aModel [
	self model: aModel
]
