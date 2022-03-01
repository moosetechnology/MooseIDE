"
Dialog used to import MSE models
"
Class {
	#name : #MiImportModelFromMSEDialog,
	#superclass : #MiImportModelDialog,
	#instVars : [
		'mooseModelDroplist'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #layout }
MiImportModelFromMSEDialog class >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #mooseModelDroplist
		  withConstraints: [ :constraints | 
			  constraints height: self toolbarHeight ];
		  yourself
]

{ #category : #opening }
MiImportModelFromMSEDialog class >> open [

	<script>
	^ self new openDialogWithSpec
]

{ #category : #specs }
MiImportModelFromMSEDialog class >> title [

	^ 'Import model from MSE file'
]

{ #category : #initialization }
MiImportModelFromMSEDialog class >> windowExtent [

	^ 300 @ (self toolbarHeight + self buttonHeight * 2)
]

{ #category : #initialization }
MiImportModelFromMSEDialog >> initializePresenters [

	super initializePresenters.
	mooseModelDroplist := self newDropList
		                      items:
			                      (MooseModel withAllSubclasses reject: [ 
					                       :model | 
					                       model isDeprecated or: [ 
							                       model canBeImportedFromFile not ] ]);
		                      yourself
]

{ #category : #action }
MiImportModelFromMSEDialog >> privateImportModel [

	^ mooseModelDroplist selectedItem new importFromMSE
]
