"
I have examples
"
Class {
	#name : #MiCoUsageMapExamples,
	#superclass : #Object,
	#category : #'MooseIDE-CoUsageMap-Examples'
}

{ #category : #examples }
MiCoUsageMapExamples >> example01Empty [
	<script: 'self new example01Empty open '>
	| v methods |
	methods := #().
	v := MiCoUsageMapBuilder new.
	v methods: methods.
	^ v
]

{ #category : #examples }
MiCoUsageMapExamples >> example02RandomGodClass [
	<script: 'self new example02RandomGodClass open'>
	| v |
	v := MiCoUsageMapBuilder new.
	v godClass: self randomGodClass.
	v legendTag
		conflictTag: 'need work' tags: { 'Frame'. 'Connection'. 'Test'. 'Base' }.
	^ v
]

{ #category : #examples }
MiCoUsageMapExamples >> example03SystemWindow [
	<script: 'self new example03SystemWindow open'>
	| v |
	v := MiCoUsageMapBuilder new.
	v godClass: SystemWindow.
	v legendTag
		conflictTag: 'need work' tags: { 'Frame'. 'Connection'. 'Test'. 'Base' }.
	^ v
]

{ #category : #examples }
MiCoUsageMapExamples >> example04PNGReadWriter [
	<script: 'self new example04PNGReadWriter open'>
	| v |
	v := MiCoUsageMapBuilder new.
	v godClass: PNGReadWriter.
	v legendTag
		conflictTag: 'need work' tags: { 'Frame'. 'Connection'. 'Test'. 'Base' }.
	^ v
]

{ #category : #examples }
MiCoUsageMapExamples >> example05FileList [
	<script: 'self new example05FileList open'>
	| v |
	v := MiCoUsageMapBuilder new.
	v godClass: FileList.
	v legendTag
		conflictTag: 'need work' tags: { 'Frame'. 'Connection'. 'Test'. 'Base' }.
	^ v
]

{ #category : #examples }
MiCoUsageMapExamples >> example06MCClassDefinition [
	<script: 'self new example06MCClassDefinition open'>
	| v |
	v := MiCoUsageMapBuilder new.
	v godClass: MCClassDefinition.
	v legendTag
		conflictTag: 'need work' tags: { 'Frame'. 'Connection'. 'Test'. 'Base' }.
	^ v
]

{ #category : #accessing }
MiCoUsageMapExamples >> randomGodClass [
	| allClasses godClasses |
	allClasses := RPackage organizer packages 
		flatCollect: [ :pkg | pkg definedClasses ].
	godClasses := allClasses select: [ :cls | 
		cls numberOfVariables > 8 
			and: [ cls methods size > 30
				and: [ cls linesOfCode > 300 ] ] ].
	
	^ godClasses atRandom
]
