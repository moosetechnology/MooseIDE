Class {
	#name : #MooseLoadMooseNexusMenuCommand,
	#superclass : #MooseAbstractLoadToolMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadMooseNexusMenuCommand class >> help [

	^ 'Load Moose Nexus. 
Build automation and dependency management for Moose models.
Nexus provides dependency analysis and management similar to Maven and Gradle when building models. It also provides structured and versioned tracking of models.
	'
]

{ #category : #accessing }
MooseLoadMooseNexusMenuCommand class >> label [

	^ 'Moose Nexus'
]

{ #category : #accessing }
MooseLoadMooseNexusMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self menuCommandOn: aBuilder forCommand: self)
		  withSeparatorAfter;
		  yourself
]

{ #category : #accessing }
MooseLoadMooseNexusMenuCommand class >> menuPriority [

	^ super menuPriority + 5
]

{ #category : #accessing }
MooseLoadMooseNexusMenuCommand >> baselineName [

	^ 'MooseNexus'
]

{ #category : #accessing }
MooseLoadMooseNexusMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/MooseNexus:', self version , '/src'
]

{ #category : #accessing }
MooseLoadMooseNexusMenuCommand >> version [

	^ 'main'
]
