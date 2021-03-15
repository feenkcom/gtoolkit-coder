Class {
	#name : #GtCoderModelExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Coders'
}

{ #category : #'private - set up' }
GtCoderModelExamples >> addFakeClassesToPackage: aPackage [
	self fakeClassNames do: [ :eachClassName |
		| aNewClass |
		aNewClass := Object subclass: eachClassName
			instanceVariableNames: (String streamContents: [ :aStream |
				self fakeInstVarNames
					do: [ :each | aStream nextPutAll: each ]
					separatedBy: [ aStream space ] ])
			classVariableNames: ''
			package: aPackage name.
		
		self fakeUnaryMethodNames do: [ :eachMethodName |
			aNewClass compile: eachMethodName classified: (self fakeCategoryForFakeMethodName: eachMethodName) ].
		self fakeKeywordMethodNames do: [ :eachMethodName |
			aNewClass compile: (eachMethodName, ' anObject') classified: (self fakeCategoryForFakeMethodName: eachMethodName) ] ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> cleanUp [
	EpMonitor disableDuring: [
		self fakeClassNames do: [ :eachClassName |
			self class environment
				at: eachClassName
				ifPresent: [ :eachClass | eachClass removeFromSystem ] ].

		(RPackageOrganizer default
			packageNamed: self fakePackageName
			ifAbsent: [ nil ]) ifNotNil: #removeFromSystem.

		(RPackageOrganizer default
			packageNamed: self renamedFakePackageName
			ifAbsent: [ nil ]) ifNotNil: #removeFromSystem ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> eventsRecorder [
	^ GtCoderExamplesEventsRecorder new
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeCategoryForFakeMethod: aCompiledMethod [
	^ 'api - ', aCompiledMethod selector
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeCategoryForFakeMethodName: aMethodName [
	^ 'api - ', aMethodName
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeClassCount [
	^ 2
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeClassNamed: aFakeClassName [
	^ self class environment at: aFakeClassName
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeClassNames [
	<script: 'self new fakeClassNames inspect'>
	| aPackageName |
	
	aPackageName := self fakePackageName.
	
	^ (1 to: self fakeClassCount) collect: [ :index | (aPackageName asCamelCase asValidSelector capitalized, 'Class', index asString) asSymbol ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeClassNamesForPackage: aPackage [
	^ self fakeClassNamesForPackageName: aPackage name
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeClassNamesForPackageName: aPackageName [	
	^ (1 to: self fakeClassCount) collect: [ :index | (aPackageName asCamelCase asValidSelector capitalized, 'Class', index asString) asSymbol ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeClassesInFakePackage: aPackage [
	^ (self fakeClassNamesForPackage: aPackage) collect: [ :eachClassName | self fakeClassNamed: eachClassName ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeClassesInSystem [
	^ self fakeClassNames select: [ :eachClassName |
		self class environment
			at: eachClassName
			ifPresent: [ true ]
			ifAbsent: [ false ] ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeClassesInSystemCount [
	^ self fakeClassesInSystem size
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeInstVarCount [
	^ 2
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeInstVarNames [
	<script: 'self new fakeInstVarNames inspect'>
	
	^ (1 to: self fakeInstVarCount) collect: [ :index | ('instVar', index asString) asSymbol ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeKeywordMethodNames [
	<script: 'self new fakeKeywordMethodNames inspect'>
	
	^ (1 to: self fakeMethodCount) collect: [ :index | (#method, index asString, ':') asSymbol ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeKeywordMethodsInFakeClass: aFakeClass [
	^ self fakeKeywordMethodNames collect: [ :each | aFakeClass >> each ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeMethodCount [
	^ 2
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeMethodNames [
	<script: 'self new fakeMethodNames inspect'>
	
	^ self fakeUnaryMethodNames, self fakeKeywordMethodNames
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeMethodsInFakeClass: aFakeClass [
	^ self fakeMethodNames collect: [ :each | aFakeClass >> each ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeMethodsInFakeClass: aFakeClass inFakePackage: aPackage [
	^ self fakeMethodNames collect: [ :each | aFakeClass >> each ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeMethodsInFakeClassNamed: aFakeClassName inFakePackage: aPackage [
	| aClass |

	aClass := self fakeClassNamed: aFakeClassName.
	^ self fakeMethodNames collect: [ :each | aClass >> each ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakePackageName [
	^ 'PackageCoderTemporary' asSymbol
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeRegisteredPackage [
	| aFakePackageName aPackage |
	
	EpMonitor disableDuring: [
		self cleanUp.

		aFakePackageName := self fakePackageName.
		self assert: (RPackageOrganizer default includesPackageNamed: aFakePackageName) not.
		
		aPackage := RPackageOrganizer default createPackageNamed: aFakePackageName.
		self addFakeClassesToPackage: aPackage ].
	
	^ aPackage
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeUnaryMethodNames [
	<script: 'self new fakeUnaryMethodNames inspect'>
	
	^ (1 to: self fakeMethodCount) collect: [ :index | (#method, index asString) asSymbol ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeUnaryMethodsInFakeClass: aFakeClass [
	^ self fakeUnaryMethodNames collect: [ :each | aFakeClass >> each ]
]

{ #category : #'private - set up' }
GtCoderModelExamples >> fakeUnregisteredPackage [
	| aFakePackageName aPackage |

	self cleanUp.
	
	aFakePackageName := self fakePackageName.
	
	self assert: (RPackageOrganizer default includesPackageNamed: aFakePackageName) not.
	
	aPackage := RPackageOrganizer default packageClass named: aFakePackageName.
	
	^ aPackage
]

{ #category : #'private - set up' }
GtCoderModelExamples >> renamedFakePackageName [
	^ (self fakePackageName, 'Renamed') asSymbol
]
