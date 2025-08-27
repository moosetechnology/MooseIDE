"
A heuristic to identify test methods based on their Java annotations

There are a number of annotations in Java that mark test methods (@Test, @Before, @BeforeEach,...)

Recognizes annotations from JUnit4 and JUnit5
"
Class {
	#name : 'MiDeadCodeJavaTestAnnotationHeuristic',
	#superclass : 'MiDeadCodeAbstractTestHeuristic',
	#category : 'MooseIDE-Dependency-DeadCode',
	#package : 'MooseIDE-Dependency',
	#tag : 'DeadCode'
}

{ #category : 'accessing' }
MiDeadCodeJavaTestAnnotationHeuristic >> description [ 

	^super description , '
	In Java, different annotations mark methods of test class
	 (@Test, @Before, @BeforeEach,...)'
]

{ #category : 'testing' }
MiDeadCodeJavaTestAnnotationHeuristic >> junit4Annotations [
	"from https://www.softwaretestinghelp.com/junit-annotations-tutorial/"

	^{ 'Test' . 'Before' . 'After' . 'BeforeClass' . 'AfterClass' }
]

{ #category : 'testing' }
MiDeadCodeJavaTestAnnotationHeuristic >> junit5Annotations [
	"from https://junit.org/junit5/docs/current/user-guide/
	other possibilities: DisplayName, DisplayNameGeneration, Nested, Tag, Disabled, AutoClose, TempDir, ExtendWith, RegisterExtension"

	^{ 'Test' . 'ParameterizedTest' . 'RepeatedTest' . 'TestFactory' . 'TestTemplate' . 'TestClassOrder' . 'TestMethodOrder' . 'TestInstance' . 'BeforeEach' . 'AfterEach' . 'BeforeAll' . 'AfterAll' . 'Timeout' }

]

{ #category : 'accessing' }
MiDeadCodeJavaTestAnnotationHeuristic >> name [

	^super name , 'Java @Test method'
]

{ #category : 'testing' }
MiDeadCodeJavaTestAnnotationHeuristic >> notDead: aTMethod [

	aTMethod annotationInstances ifEmpty: [ ^false ].

	(aTMethod annotationInstances anySatisfy: [ :annotation |
		self junit4Annotations includes: annotation annotationType name ])
		ifTrue: [ ^true ].

	(aTMethod annotationInstances anySatisfy: [ :annotation |
		self junit5Annotations includes: annotation annotationType name ]) 
		ifTrue: [ ^true ].

	^false
]
