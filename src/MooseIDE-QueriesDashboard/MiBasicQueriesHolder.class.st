Class {
	#name : 'MiBasicQueriesHolder',
	#superclass : 'MiAbstractQueriesHolder',
	#instVars : [
		'classes',
		'packages',
		'enums',
		'withEnum',
		'withAnnotation',
		'methods'
	],
	#category : 'MooseIDE-QueriesDashboard-Queries',
	#package : 'MooseIDE-QueriesDashboard',
	#tag : 'Queries'
}

{ #category : 'testing' }
MiBasicQueriesHolder class >> canBeAppliedOnModel: aMooseModel [

	^ false
]

{ #category : 'queries - class' }
MiBasicQueriesHolder >> abstractClassesWithoutSubclass [
		<query>
	^ DQueryResult new
		  name: 'Abstract classes without subclass';
		  group: 'Classes';
		  queryBlock: [ 
			  self classes select: [ :c | c isAbstract isNotNil and: [ c isAbstract and: [ c subInheritances isEmpty ] ] ] ] ;
		  yourself
]

{ #category : 'accessing' }
MiBasicQueriesHolder >> classes [

	^ classes
]

{ #category : 'accessing' }
MiBasicQueriesHolder >> classes: anObject [

	classes := anObject
]

{ #category : 'queries - method' }
MiBasicQueriesHolder >> classesWhoseAmethodHasACyclomaticComplexitySupTo: aNumber [
		<query>
	^ DQueryResult new
		  name: 'Classes whose at least a method has a cyclomatic complexity superior to X';
		  group: 'Methods';
		  queryBlock: [ 
			  ((self methods) select: [ :m | m cyclomaticComplexity > aNumber ]) collect: #parentType  ] ;
		  yourself
]

{ #category : 'queries - class' }
MiBasicQueriesHolder >> classesWithANumberOfAttributesSupTo: aNumber [
		<query>
	^ DQueryResult new
		  name: 'Classes with more than X attributes';
		  group: 'Classes';
		  queryBlock: [ 
			  self classes select: [ :c | c attributes size > aNumber ] ] ;
		  yourself
]

{ #category : 'queries - class' }
MiBasicQueriesHolder >> classesWithANumberOfLOCSupTo: aNumber [
		<query>
	^ DQueryResult new
		  name: 'Classes with more than X lines of code';
		  group: 'Classes';
		  queryBlock: [ 
			  self classes select: [ :c | c numberOfLinesOfCode > aNumber ] ] ;
		  yourself
]

{ #category : 'queries - class' }
MiBasicQueriesHolder >> classesWithANumberOfMethodsSupTo: aNumber [
		<query>
	^ DQueryResult new
		  name: 'Classes with more than X methods';
		  group: 'Classes';
		  queryBlock: [ 
			  self classes select: [ :c | c methods  size > aNumber ] ] ;
		  yourself
]

{ #category : 'queries - class' }
MiBasicQueriesHolder >> deadClasses [
		<query>
	^ DQueryResult new
		  name: 'Dead classes';
		  group: 'Classes';
		  queryBlock: [ 
			  self classes select: [ :c | (c queryIncoming: FamixTAssociation) isEmpty] ] ;
		  yourself
]

{ #category : 'queries - method' }
MiBasicQueriesHolder >> deadMethods [

	<query>
	^ DQueryResult new
		  name:
			  'Dead methods (not invoked by any methods)';
		  group: 'Methods';
		  queryBlock: [ 
			  self methods select: [ :m | (m queryIncoming: FamixTInvocation) isEmpty ] ] ;
		  yourself
]

{ #category : 'queries - method' }
MiBasicQueriesHolder >> deprecatedAndCalledMethods [

	<query>
	^ DQueryResult new
		  name:
			  'Deprecated but called methods';
		  group: 'Methods';
		  queryBlock: [ 
			self withAnnotation ifTrue: [  | deprecated |
			  deprecated := self deprecatedMethods result.
			  deprecated select: [ :m | ((m queryIncoming: FamixTInvocation) collect: #sender)  allSatisfy: [ :s | (self deprecatedMethods result includes: s) not ]  ] ] ];
		  yourself
]

{ #category : 'queries - method' }
MiBasicQueriesHolder >> deprecatedMethods [

	<query>
	^ DQueryResult new
		  name:
			  'Deprecated methods';
		  group: 'Methods';
		  queryBlock: [ 
			self withAnnotation ifTrue: [  
			  self methods select: [ :m | 
        m annotationInstances notEmpty
            and: [ m annotationTypes anySatisfy: [ :a | a name = 'Deprecated' ] ] ] ] ];
		  yourself
]

{ #category : 'query - enum' }
MiBasicQueriesHolder >> enumWithANumberOfValuesSupTo: aNumber [
		<query>
	^ DQueryResult new
		  name: 'Enumerations with more than X values';
		  group: 'Enumeration';
		  queryBlock: [ 
			  self enums select: [ :e | e enumValues  size > aNumber ] ] ;
		  yourself
]

{ #category : 'query - enum' }
MiBasicQueriesHolder >> enumWithMethods [
		<query>
	^ DQueryResult new
		  name: 'Enumerations with methods';
		  group: 'Enumeration';
		  queryBlock: [ 
			  self enums select: [ :e | e methods isNotEmpty ] ] ;
		  yourself
]

{ #category : 'accessing' }
MiBasicQueriesHolder >> enums [

	^ enums
]

{ #category : 'accessing' }
MiBasicQueriesHolder >> enums: anObject [

	enums := anObject
]

{ #category : 'initialization' }
MiBasicQueriesHolder >> initializeAnnotationTypes [

	| tAnnotationType |
	tAnnotationType := self mooseModel metamodel traits detect: [ :trait | 
		         trait name = #TAnnotationType ].
	^ tAnnotationType classUsers 
		ifEmpty: [
			withAnnotation := false.
			OrderedCollection new ] 
		ifNotEmpty: [ 
		  withAnnotation := true.
		  self mooseModel allAnnotationTypes  ]
]

{ #category : 'initialization' }
MiBasicQueriesHolder >> initializeClasses [

	| exception |
	"If the metamodel contains exception, class exceptions are removed from collection "
	exception := self mooseModel metamodel traits detect: [ :trait | 
		             trait name = #TException ].
	^ exception classUsers
		ifEmpty: [ self mooseModel allModelClasses reject: [ :c | c isAnonymousClass ] ]
		ifNotEmpty: [ self mooseModel allModelClasses reject: [ :c | 
				             c isException or: [ c isAnonymousClass ] ] ].

]

{ #category : 'initialization' }
MiBasicQueriesHolder >> initializeEntities [

	classes := self initializeClasses .
	enums := self initializeEnums.
	packages := mooseModel allModelPackages .
	methods := mooseModel allModelMethods.
	self initializeAnnotationTypes.
	
]

{ #category : 'initialization' }
MiBasicQueriesHolder >> initializeEnums [

	| tEnum |
	tEnum := self mooseModel metamodel traits detect: [ :trait | 
		         trait name = #TEnum ].
	^ tEnum classUsers 
		ifEmpty: [
			withEnum := false.
			OrderedCollection new ] 
		ifNotEmpty: [ 
		  withEnum := true.
		  self mooseModel allEnums reject: [ :e | e isStub ] ]
]

{ #category : 'queries - packages' }
MiBasicQueriesHolder >> leafPackages [
		<query>
	^ DQueryResult new
		  name: 'Leaf Packages';
		  group: 'Packages';
		  queryBlock: [ 
			  self packages reject: [ :p | p children anySatisfy: [ :c | c isPackage ] ] ];
		  yourself
]

{ #category : 'accessing' }
MiBasicQueriesHolder >> methods [

	^ methods
]

{ #category : 'accessing' }
MiBasicQueriesHolder >> methods: anObject [

	methods := anObject
]

{ #category : 'queries - method' }
MiBasicQueriesHolder >> methodsAccessingMoreAttributesThan: aNumber [

	<query>
	^ DQueryResult new
		  name:
			  'Methods with more than X accesses to Attributes or Enum Values';
		  group: 'Methods';
		  queryBlock: [ 
			  self methods select: [ :m | ((m accesses select: [ :a | a variable isAttribute ]) collectAsSet: #variable) size > aNumber] ];
		  yourself
]

{ #category : 'queries - method' }
MiBasicQueriesHolder >> methodsWithACyclomaticComplexitySupTo: aNumber [
		<query>
	^ DQueryResult new
		  name: 'Methods with a cyclomatic complexity superior to X';
		  group: 'Methods';
		  queryBlock: [ 
			  self methods select: [ :m | m cyclomaticComplexity > aNumber ] ] ;
		  yourself
]

{ #category : 'queries - method' }
MiBasicQueriesHolder >> methodsWithANumberOfAccessesSupTo: aNumber [
		<query>
	^ DQueryResult new
		  name: 'Methods with more than X accesses to Attributes or Enum Values';
		  group: 'Methods';
		  queryBlock: [ 
			  self methods select: [ :m | (m accesses select: [ :a | a variable isAttribute or: [self withEnum and: [ a variable isEnumValue ] ] ]) size > aNumber ] ] ;
		  yourself
]

{ #category : 'queries - class' }
MiBasicQueriesHolder >> notImplementedInterfaces [
		<query>
		| tInterface |
	tInterface := self mooseModel metamodel traits detect: [ :trait | 
		             trait name = #TImplementable ].
	^ DQueryResult new
		  name: 'Not implemented interfaces';
		  group: 'Interfaces';
		  queryBlock: [ 
			tInterface classUsers ifEmpty: [ OrderedCollection new ] ifNotEmpty: 
			  [self mooseModel allModelEntities select: [ :e | e isInterface and: [ e implementations isEmpty ] ] ] ] ;
		  yourself
]

{ #category : 'accessing' }
MiBasicQueriesHolder >> packages [

	^ packages
]

{ #category : 'accessing' }
MiBasicQueriesHolder >> packages: anObject [

	packages := anObject
]

{ #category : 'queries - packages' }
MiBasicQueriesHolder >> packagesWithANumberOfClassesSupTo: aNumber [
		<query>
	^ DQueryResult new
		  name: 'Packages with more than X classes';
		  group: 'Packages';
		  queryBlock: [ 
			  self packages select: [ :p | (p types select: #isClass) size > aNumber ] ] ;
		  yourself
]

{ #category : 'queries - packages' }
MiBasicQueriesHolder >> packagesWithOneClass [
		<query>
	^ DQueryResult new
		  name: 'Packages with only one class';
		  group: 'Packages';
		  queryBlock: [ 
			  self packages select: [ :p | (p types select: #isClass) size = 1 ] ] ;
		  yourself
]

{ #category : 'accessing' }
MiBasicQueriesHolder >> withAnnotation [

	^ withAnnotation
]

{ #category : 'queries - method' }
MiBasicQueriesHolder >> withEnum [ 
	^ withEnum
]
