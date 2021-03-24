Class {
	#name : #GtPharoDummiesGenerator,
	#superclass : #Object,
	#instVars : [
		'amountOfPackages',
		'amountOfClasses'
	],
	#category : #'GToolkit-Coder-Pharo-Examples-Dummies'
}

{ #category : #'api - generation' }
GtPharoDummiesGenerator class >> withPackages: anAmountOfPackages classes: anAmountOfClasses [
	^ self new
		amountOfPackages: anAmountOfPackages;
		amountOfClasses: anAmountOfClasses;
		generate
]

{ #category : #'private - generation' }
GtPharoDummiesGenerator >> addDummyClassesToPackage: aDummyPackage [
	| theDummyClasses |
	theDummyClasses := (self dummyClassNamesForPackageName: aDummyPackage packageName) collect: [ :eachClassName |
		| aNewClass aDummyClass |

		aNewClass := Object subclass: eachClassName
			instanceVariableNames: (String streamContents: [ :aStream |
				self fakeInstVarNames
					do: [ :each | aStream nextPutAll: each ]
					separatedBy: [ aStream space ] ])
			classVariableNames: ''
			package: aDummyPackage packageName.
		
		aDummyClass := GtPharoDummyClass new
			instVarNames: self fakeInstVarNames;
			realClass: aNewClass;
			className: eachClassName.
		
		self addDummyUnaryMethodsToClass: aDummyClass.
		self addDummyUnaryClassMethodsToClass: aDummyClass.
		self addDummyKeywordMethodsToClass: aDummyClass.

		aDummyClass ].
	
	aDummyPackage dummyClasses: theDummyClasses
]

{ #category : #'private - generation' }
GtPharoDummiesGenerator >> addDummyKeywordMethodsToClass: aDummyClass [
	| theDummyMethods |
	
	theDummyMethods := self fakeKeywordMethodNames collect: [ :eachMethodName |
		| eachProtocol aDummyMethod |
		
		eachProtocol := self fakeCategoryForFakeMethodName: eachMethodName.
		
		aDummyClass realClass
			compile: (eachMethodName asString, ' anObject')
			classified: eachProtocol.
		
		aDummyMethod := GtPharoDummyMethod new
			realMethod: aDummyClass realClass >> eachMethodName;
			selector: eachMethodName;
			protocol: eachProtocol.

		aDummyMethod ].

	aDummyClass addDummyMethods: theDummyMethods
]

{ #category : #'private - generation' }
GtPharoDummiesGenerator >> addDummyUnaryClassMethodsToClass: aDummyClass [
	| theDummyMethods |
	theDummyMethods := self dummyUnaryClassMethodNames collect: [ :eachMethodName |
		| eachProtocol aDummyMethod |
		
		eachProtocol := self fakeCategoryForFakeMethodName: eachMethodName.
		
		aDummyClass realClass class
			compile: eachMethodName
			classified: eachProtocol.
			
		aDummyMethod := GtPharoDummyMethod new
			realMethod: aDummyClass realClass class >> eachMethodName;
			selector: eachMethodName;
			protocol: eachProtocol.
			
		aDummyMethod ].
	
	aDummyClass addDummyClassMethods: theDummyMethods
]

{ #category : #'private - generation' }
GtPharoDummiesGenerator >> addDummyUnaryMethodsToClass: aDummyClass [
	| theDummyMethods |
	theDummyMethods := self dummyUnaryMethodNames collect: [ :eachMethodName |
		| eachProtocol aDummyMethod |
		
		eachProtocol := self fakeCategoryForFakeMethodName: eachMethodName.
		
		aDummyClass realClass
			compile: eachMethodName
			classified: eachProtocol.
			
		aDummyMethod := GtPharoDummyMethod new
			realMethod: aDummyClass realClass >> eachMethodName;
			selector: eachMethodName;
			protocol: eachProtocol.
			
		aDummyMethod ].
	
	aDummyClass addDummyMethods: theDummyMethods
]

{ #category : #accessing }
GtPharoDummiesGenerator >> amountOfClasses [
	^ amountOfClasses
]

{ #category : #accessing }
GtPharoDummiesGenerator >> amountOfClasses: anObject [
	amountOfClasses := anObject
]

{ #category : #accessing }
GtPharoDummiesGenerator >> amountOfPackages [
	^ amountOfPackages
]

{ #category : #accessing }
GtPharoDummiesGenerator >> amountOfPackages: anObject [
	amountOfPackages := anObject
]

{ #category : #'private - names' }
GtPharoDummiesGenerator >> dummyClassNamesForPackageName: aPackageName [	
	^ (1 to: amountOfClasses) collect: [ :index | (aPackageName asCamelCase asValidSelector capitalized, 'Class', index asString) asSymbol ]
]

{ #category : #'private - names' }
GtPharoDummiesGenerator >> dummyPackageNamePrefix [
	^ 'TemporaryPackage'
]

{ #category : #'private - names' }
GtPharoDummiesGenerator >> dummyPackageNames [
	<script: #'self new dummyPackageNames inspect'>
	| thePackageNames |
	
	thePackageNames := OrderedCollection new.
	[ thePackageNames size < amountOfPackages ] whileTrue: [
		| aGeneratedPackageName |
		
		aGeneratedPackageName := (self dummyPackageNamePrefix, '-', (UUIDGenerator next asString36 last: 8) capitalized) asSymbol.

		(RPackageOrganizer default includesPackageNamed: aGeneratedPackageName)
			ifFalse: [ thePackageNames add: aGeneratedPackageName ] ].

	^ thePackageNames
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> dummyUnaryClassMethodNames [
	<script: 'self new dummyUnaryClassMethodNames inspect'>
	
	^ (1 to: self fakeMethodCount) collect: [ :index | (#classMethod, index asString) asSymbol ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> dummyUnaryMethodNames [
	<script: 'self new dummyUnaryMethodNames inspect'>
	
	^ (1 to: self fakeMethodCount) collect: [ :index | (#method, index asString) asSymbol ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeCategoryForFakeMethod: aCompiledMethod [
	^ 'api - ', aCompiledMethod selector
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeCategoryForFakeMethodName: aMethodName [
	^ 'api - ', aMethodName
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeClassCount [
	^ 2
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeClassNamed: aFakeClassName [
	^ self class environment at: aFakeClassName
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeClassNamesForPackage: aPackage [
	^ self fakeClassNamesForPackageName: aPackage name
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeClassNamesForPackageName: aPackageName [	
	^ (1 to: self fakeClassCount) collect: [ :index | (aPackageName asCamelCase asValidSelector capitalized, 'Class', index asString) asSymbol ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeClassesInFakePackage: aPackage [
	^ (self fakeClassNamesForPackage: aPackage) collect: [ :eachClassName | self fakeClassNamed: eachClassName ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeClassesInSystem [
	^ self fakeClassNames select: [ :eachClassName |
		self class environment
			at: eachClassName
			ifPresent: [ true ]
			ifAbsent: [ false ] ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeClassesInSystemCount [
	^ self fakeClassesInSystem size
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeInstVarCount [
	^ 2
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeInstVarNames [
	<script: 'self new fakeInstVarNames inspect'>
	
	^ (1 to: self fakeInstVarCount) collect: [ :index | ('instVar', index asString) asSymbol ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeKeywordMethodNames [
	<script: 'self new fakeKeywordMethodNames inspect'>
	
	^ (1 to: self fakeMethodCount) collect: [ :index | (#method, index asString, ':') asSymbol ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeKeywordMethodsInFakeClass: aFakeClass [
	^ self fakeKeywordMethodNames collect: [ :each | aFakeClass >> each ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeMethodCount [
	^ 2
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeMethodNames [
	<script: 'self new fakeMethodNames inspect'>
	
	^ self fakeUnaryMethodNames, self fakeKeywordMethodNames
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeMethodsInFakeClass: aFakeClass [
	^ self fakeMethodNames collect: [ :each | aFakeClass >> each ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeMethodsInFakeClass: aFakeClass inFakePackage: aPackage [
	^ self fakeMethodNames collect: [ :each | aFakeClass >> each ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeMethodsInFakeClassNamed: aFakeClassName inFakePackage: aPackage [
	| aClass |

	aClass := self fakeClassNamed: aFakeClassName.
	^ self fakeMethodNames collect: [ :each | aClass >> each ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeRegisteredPackage [
	| aFakePackageName aPackage |
	
	EpMonitor disableDuring: [
		self cleanUp.
		
		amountOfPackages timesCollect: [  ].

		aFakePackageName := self fakePackageName.
		self assert: (RPackageOrganizer default includesPackageNamed: aFakePackageName) not.
		
		aPackage := RPackageOrganizer default createPackageNamed: aFakePackageName.
		self addFakeClassesToPackage: aPackage ].
	
	^ aPackage
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeUnaryMethodsInFakeClass: aFakeClass [
	^ self fakeUnaryMethodNames collect: [ :each | aFakeClass >> each ]
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> fakeUnregisteredPackage [
	| aFakePackageName aPackage |

	self cleanUp.
	
	aFakePackageName := self fakePackageName.
	
	self assert: (RPackageOrganizer default includesPackageNamed: aFakePackageName) not.
	
	aPackage := RPackageOrganizer default packageClass named: aFakePackageName.
	
	^ aPackage
]

{ #category : #'api - generation' }
GtPharoDummiesGenerator >> generate [
	<script: #'self new generate inspect'>
	| aDummyEnvironment |
	
	aDummyEnvironment := GtPharoDummyEnvironment new.
	
	EpMonitor disableDuring: [
		| theDummyPackages |
		
		theDummyPackages := self dummyPackageNames collect: [ :eachPackageName |
			| eachPackage eachDummyPackage |
			self assert: (RPackageOrganizer default includesPackageNamed: eachPackageName) not.
			eachPackage := RPackageOrganizer default createPackageNamed: eachPackageName.
			eachDummyPackage := GtPharoDummyPackage new
				packageName: eachPackageName;
				realPackage: eachPackage.
			self addDummyClassesToPackage: eachDummyPackage.
			eachDummyPackage ].
		
		aDummyEnvironment dummyPackages: theDummyPackages ].

	^ aDummyEnvironment
]

{ #category : #initialization }
GtPharoDummiesGenerator >> initialize [
	super initialize.
	
	amountOfPackages := 2.
	amountOfClasses := 2
]

{ #category : #'private - set up' }
GtPharoDummiesGenerator >> renamedFakePackageName [
	^ (self fakePackageName, 'Renamed') asSymbol
]
