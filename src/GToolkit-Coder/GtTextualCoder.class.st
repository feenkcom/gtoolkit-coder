Class {
	#name : #GtTextualCoder,
	#superclass : #GtCoderModel,
	#instVars : [
		'sourceCode',
		'completionStrategy',
		'astPromise'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'private - addons' }
GtTextualCoder >> addOnsClass [
	^ GtTextualCoderAddOns
]

{ #category : #'api - text' }
GtTextualCoder >> appendString: aString [
	self critical: [
		self sourceCode appendString: aString.
		self sourceChanged ]
]

{ #category : #'api - text' }
GtTextualCoder >> appendText: aText [
	self critical: [
		self sourceCode appendText: aText.
		self sourceChanged ]
]

{ #category : #'api - text' }
GtTextualCoder >> appendText: aText with: aGtCoderUpdateStragegy [
	self critical: [
		self sourceCode appendText: aText.
		self sourceChangedWith: aGtCoderUpdateStragegy ]
]

{ #category : #'api - converting' }
GtTextualCoder >> asNewCoderModelWithSameSubject [
	"Return new coder model with same subject (e.g., package, class, method)"
	<return: #GtCoderModel>

	^ self shouldNotImplement
]

{ #category : #'api - ast' }
GtTextualCoder >> ast [
	<return: #TAsyncPromise of: #GtCoderAst>

	^ self critical: [ astPromise ifNil: [ astPromise := self sourceCode currentSourceString asyncThen: [ :aGtCoderSourceString |
		GtCoderAst new
			ast: (self computeAst: aGtCoderSourceString string);
			epoch: aGtCoderSourceString epoch ] ] ]
]

{ #category : #'api - ast' }
GtTextualCoder >> astAsyncDo: aBlock [
	self ast asyncThen: [ :aGtCoderAst | aBlock value: aGtCoderAst ast ]
]

{ #category : #'api - ast' }
GtTextualCoder >> astAwait [
	^ self ast wait ast
]

{ #category : #'api - ast' }
GtTextualCoder >> astAwaitDo: aBlock [
	aBlock value: self astAwait
]

{ #category : #'api - text' }
GtTextualCoder >> collapsedText [
	<return: #BlText>

	^ self collapsedTextPromise wait
]

{ #category : #'api - text' }
GtTextualCoder >> collapsedTextPromise [
	<return: #TAsyncPromise of: #BlText>

	^ self currentSourceTextPromise asyncThen: [ :aCurrentText |
		aCurrentText
			ifEmpty: [ '' asRopedText ]
			ifNotEmpty: [ aCurrentText iterator nextLine ] ]
]

{ #category : #'api - accessing' }
GtTextualCoder >> completionStrategy [
	<return: #GtCompletionStrategy>

	^ completionStrategy
		ifNil: [ completionStrategy := self newCompletionStrategy ]
]

{ #category : #'api - accessing' }
GtTextualCoder >> completionStrategy: aGtCompletionStrategy [
	completionStrategy := aGtCompletionStrategy
]

{ #category : #'api - ast' }
GtTextualCoder >> computeAst [
	^ self computeAst: self currentSourceString
]

{ #category : #'api - ast' }
GtTextualCoder >> computeAst: theSourceString [
	^ self subclassResponsibility
]

{ #category : #'api - text' }
GtTextualCoder >> correctFrom: aFromIndex to: aToIndex with: aString [
	self critical: [
		self sourceCode
			replaceFrom: aFromIndex
			to: aToIndex
			withString: aString.
		self sourceChanged.
		self notifyCorrectionFrom: aFromIndex to: aToIndex with: aString ]
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceString [
	"Return a String representation of the current source text"
	<return: #String>

	^ self currentSourceStringPromise wait
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceString: aString [
	"Set a new source text"

	self critical: [
		self sourceCode currentSourceString: aString.
		self sourceChanged ]
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceStringPromise [
	"Return a String representation of the current source text"
	<return: #TAsyncPromise of: #String>

	^ self critical: [ self sourceCode currentSourceString then: [ :aGtCoderSourceString | aGtCoderSourceString string ] ]
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceText [
	"Set a new source text"

	^ self currentSourceTextPromise wait
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceText: aText [
	"Set a new source text"

	self critical: [ 
		self sourceCode currentSourceText: aText.
		self sourceChanged ]
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceText: aText with: aGtCoderUpdateStragegy [
	"Set a new source text"

	self critical: [ 
		self sourceCode currentSourceText: aText.
		self sourceChangedWith: aGtCoderUpdateStragegy ]
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceTextPromise [
	<return: #TAsyncPromise of: #BlText>

	^ self critical: [ self sourceCode currentSourceText then: [ :aGtCoderSourceText | aGtCoderSourceText text ] ]
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceTextSynchronously: aText [
	"Set a new source text"

	self critical: [
		self sourceCode currentSourceText: aText.
		self sourceChangedWith: GtCoderUpdateStrategy new makeSynchronous ]
]

{ #category : #'api - text' }
GtTextualCoder >> deleteSourceTextFrom: aFromIndex to: aToIndex [
	self critical: [
		self sourceCode delete: aFromIndex to: aToIndex.
		self sourceChanged ]
]

{ #category : #'api - ast' }
GtTextualCoder >> ensureAst [
	self astAsyncDo: [ :theAst | ]
]

{ #category : #initialize }
GtTextualCoder >> initialize [
	super initialize.

	self reset
]

{ #category : #testing }
GtTextualCoder >> isModified [
	<return: #Boolean>

	^ self sourceCode isModified
]

{ #category : #'instance creation' }
GtTextualCoder >> newCompletionStrategy [
	^ self subclassResponsibility
]

{ #category : #'private - notifying' }
GtTextualCoder >> notifyCorrectionFrom: aFromIndex to: aToIndex with: aString [
	self announce: (GtCoderCorrectionRequest new
		coder: self;
		fromIndex: aFromIndex;
		toIndex: aToIndex;
		correctionString: aString)
]

{ #category : #'private - notifying' }
GtTextualCoder >> notifySourceChangedWith: anUpdateStragegy [
	"Notify the text editor that it should update the text (for example due to refactoring changes)"
	
	self announce: (GtCoderSourceCodeChanged new 
		updateStrategy: anUpdateStragegy;
		coder: self)
]

{ #category : #private }
GtTextualCoder >> pragmasNamed: aSymbol inHierarchy: aClass [
	| actions |
	actions := OrderedCollection new.
	aClass withAllSuperclassesDo: [ :each | actions addAll: (Pragma allNamed: aSymbol in: each) ].
	actions sort: [ :a :b | a arguments first < b arguments first ].
	^ actions
]

{ #category : #'api - text' }
GtTextualCoder >> requestStyleSourceText [
	"Request the text editor to restyle the text (for example due to environmental changes)"

	self resetAstCache.
	self announce: (GtCoderStyleTextRequest new coder: self)
]

{ #category : #initialize }
GtTextualCoder >> reset [
	self resetAstCache.

	"initialized lazily in #sourceCode"
	sourceCode := nil.
	completionStrategy := nil
]

{ #category : #'private - ast' }
GtTextualCoder >> resetAstCache [
	astPromise := nil
]

{ #category : #'event handling' }
GtTextualCoder >> sourceChanged [
	self sourceChangedWith: GtCoderUpdateStrategy new makeAsynchronous
]

{ #category : #'event handling' }
GtTextualCoder >> sourceChangedWith: anUpdateStrategy [
	astPromise := nil.
	self notifySourceChangedWith: anUpdateStrategy.
]

{ #category : #'api - accessing' }
GtTextualCoder >> sourceCode [
	<return: #GtCoderTextSource>

	sourceCode ifNil: [ self sourceCode: (GtCoderExplicitSourceCode new source: '') ].
	^ sourceCode
]

{ #category : #'api - accessing' }
GtTextualCoder >> sourceCode: aGtCoderSourceCode [
	"Set the source code of this coder to a given one and notify about the changes"
	
	self 
		sourceCode: aGtCoderSourceCode 
		withStrategy: GtCoderUpdateStrategy new makeAsynchronous
]

{ #category : #'api - accessing' }
GtTextualCoder >> sourceCode: aGtCoderSourceCode withStrategy: anUpdateStragegy [
	"Set the source code of this coder to a given one and notify about the changes"
	
	sourceCode := aGtCoderSourceCode.
	self sourceChangedWith: anUpdateStragegy.
]

{ #category : #'api - accessing' }
GtTextualCoder >> sourceCodeSynchronously: aGtCoderSourceCode [
	self
		sourceCode: aGtCoderSourceCode 
		withStrategy: GtCoderUpdateStrategy new makeSynchronous
]

{ #category : #'api - text' }
GtTextualCoder >> sourceText [
	<return: #TAsyncPromise>

	self
		deprecated: 'Use #currentSourceText'
		transformWith: '`@receiver sourceText' -> '`@receiver currentSourceText'.

	^ self currentSourceText
]

{ #category : #'api - text' }
GtTextualCoder >> sourceTextDo: aBlock [
	"Evaluate a given block with my source code text if present"

	^ self sourceCode sourceTextDo: aBlock
]

{ #category : #'api - addons' }
GtTextualCoder >> stylers [
	^ #()
]

{ #category : #'api - ast' }
GtTextualCoder >> supportsAstCache [
	"Return true if ast cache should be used, false otherwise"

	^ true
]
