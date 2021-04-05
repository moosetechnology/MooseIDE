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
	#name : #MiAbstractDependencyBrowser,
	#superclass : #MiAbstractBrowser,
	#category : #'Midas-Dependency'
}

{ #category : #testing }
MiAbstractDependencyBrowser class >> isAbstract [ 
	^ self == MiAbstractDependencyBrowser
]

{ #category : #'as yet unclassified' }
MiAbstractDependencyBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: self toolbarDependencyName)
		parent: (self midasBrowserMenuLabel) ;
		order: 30 ;
		label: 'Dependency'
]

{ #category : #'as yet unclassified' }
MiAbstractDependencyBrowser class >> toolbarDependencyName [
	^ 'MidasDependencyBrowser'
]
