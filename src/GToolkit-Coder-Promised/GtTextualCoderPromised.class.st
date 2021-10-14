Class {
	#name : #GtTextualCoderPromised,
	#superclass : #GtCoderModel,
	#instVars : [
		'sourceCode',
		'completionStrategy',
		'astPromise'
	],
	#category : #'GToolkit-Coder-Promised'
}

{ #category : #'as yet unclassified' }
GtTextualCoderPromised >> addCopyCutPasteContextMenuAddOnsAst: anAst to: coderAddOns [
	<gtCoderContextMenuAddOns: 10>
	coderAddOns
		addContextMenuItem: 'Cut'
			action: [ :aCoderViewModel :anEditorElement | anEditorElement editor cutSelected ]
			id: GtTextualCoderCutContextMenuItemId;
		addContextMenuItem: 'Copy'
			action: [ :aCoderViewModel :anEditorElement | anEditorElement editor copySelected ]
			id: GtTextualCoderCopyContextMenuItemId;
		addContextMenuItem: 'Paste'
			action: [ :aCoderViewModel :anEditorElement | anEditorElement editor paste ]
			id: GtTextualCoderPasteContextMenuItemId
]

{ #category : #'private - addons' }
GtTextualCoderPromised >> addOnsClass [
	^ GtTextualCoderAddOns
]

{ #category : #converting }
GtTextualCoderPromised >> asCoderViewModel [
	^ GtTextualCoderViewModelPromised new coder: self
]

{ #category : #'api - converting' }
GtTextualCoderPromised >> asNewCoderModelWithSameSubject [
	"Return new coder model with same subject (e.g., package, class, method)"
	<return: #GtCoderModel>

	^ self shouldNotImplement
]

{ #category : #'api - ast' }
GtTextualCoderPromised >> ast [
	<return: #TAsyncPromise of: #GtCoderAst>

	^ self critical: [ astPromise ifNil: [ astPromise := self sourceCode currentSourceString asyncThen: [ :aGtCoderSourceString |
		GtCoderAst new
			ast: (self computeAst: aGtCoderSourceString string);
			epoch: aGtCoderSourceString epoch ] ] ]
]

{ #category : #'api - ast' }
GtTextualCoderPromised >> astAwait [
	^ self ast wait ast
]

{ #category : #'as yet unclassified' }
GtTextualCoderPromised >> breadcrumbActions [
	<return: #Array of: #GtSourceCoderBreadcrumbAction>

	^ #()
]

{ #category : #'api - accessing' }
GtTextualCoderPromised >> completionStrategy [
	<return: #GtCompletionStrategy>

	^ completionStrategy
		ifNil: [ completionStrategy := self newCompletionStrategy ]
]

{ #category : #'api - accessing' }
GtTextualCoderPromised >> completionStrategy: aGtCompletionStrategy [
	completionStrategy := aGtCompletionStrategy
]

{ #category : #'api - ast' }
GtTextualCoderPromised >> computeAst: aString [
	^ self subclassResponsibility
]

{ #category : #'api - text' }
GtTextualCoderPromised >> correctFrom: aFromIndex to: aToIndex with: aString [
	self critical: [
		self sourceCode
			replaceFrom: aFromIndex
			to: aToIndex
			withString: aString.
		self sourceChanged.
		self notifyCorrectionFrom: aFromIndex to: aToIndex with: aString ]
]

{ #category : #'api - text' }
GtTextualCoderPromised >> currentSourceString [
	"Return a String representation of the current source text"
	<return: #TAsyncPromise of: #String>

	^ self critical: [ self sourceCode currentSourceString then: [ :aGtCoderSourceString | aGtCoderSourceString string ] ]
]

{ #category : #'api - text' }
GtTextualCoderPromised >> currentSourceString: aString [
	"Set a new source text"

	self critical: [
		self sourceCode currentSourceString: aString.
		self sourceChanged ]
]

{ #category : #'api - text' }
GtTextualCoderPromised >> currentSourceText [
	<return: #TAsyncPromise of: #BlText>

	^ self critical: [ self sourceCode currentSourceText then: [ :aGtCoderSourceText | aGtCoderSourceText text ] ]
]

{ #category : #'api - text' }
GtTextualCoderPromised >> currentSourceText: aText [
	"Set a new source text"

	self critical: [ 
		self sourceCode currentSourceText: aText.
		self sourceChanged ]
]

{ #category : #'api - text' }
GtTextualCoderPromised >> currentSourceText: aText with: aGtCoderUpdateStragegy [
	"Set a new source text"

	self critical: [ 
		self sourceCode currentSourceText: aText.
		self sourceChangedWith: aGtCoderUpdateStragegy ]
]

{ #category : #'api - text' }
GtTextualCoderPromised >> currentSourceTextSynchronously: aText [
	"Set a new source text"

	self critical: [
		self sourceCode currentSourceText: aText.
		self sourceChangedWith: GtCoderUpdateStrategy new makeSynchronous ]
]

{ #category : #initialize }
GtTextualCoderPromised >> initialize [
	super initialize.

	self reset
]

{ #category : #testing }
GtTextualCoderPromised >> isModified [
	<return: #Boolean>

	^ self sourceCode isModified
]

{ #category : #'instance creation' }
GtTextualCoderPromised >> newCompletionStrategy [
	^ self subclassResponsibility
]

{ #category : #'private - notifying' }
GtTextualCoderPromised >> notifyCorrectionFrom: aFromIndex to: aToIndex with: aString [
	self announce: (GtCoderCorrectionRequest new
		coder: self;
		fromIndex: aFromIndex;
		toIndex: aToIndex;
		correctionString: aString)
]

{ #category : #'private - notifying' }
GtTextualCoderPromised >> notifySourceChangedWith: anUpdateStragegy [
	"Notify the text editor that it should update the text (for example due to refactoring changes)"
	
	self announce: (GtCoderSourceCodeChanged new 
		updateStrategy: anUpdateStragegy;
		coder: self)
]

{ #category : #private }
GtTextualCoderPromised >> pragmasNamed: aSymbol inHierarchy: aClass [
	| actions |
	actions := OrderedCollection new.
	aClass withAllSuperclassesDo: [ :each | actions addAll: (Pragma allNamed: aSymbol in: each) ].
	actions sort: [ :a :b | a arguments first < b arguments first ].
	^ actions
]

{ #category : #'api - text' }
GtTextualCoderPromised >> requestStyleSourceText [
	"Request the text editor to restyle the text (for example due to environmental changes)"

	self resetAstCache.
	self announce: (GtCoderStyleTextRequest new coder: self)
]

{ #category : #initialize }
GtTextualCoderPromised >> reset [
	self resetAstCache.

	"initialized lazily in #sourceCode"
	sourceCode := nil.
	completionStrategy := nil
]

{ #category : #'private - ast' }
GtTextualCoderPromised >> resetAstCache [
	astPromise := nil
]

{ #category : #'private - notifying' }
GtTextualCoderPromised >> sourceChanged [
	self sourceChangedWith: GtCoderUpdateStrategy new makeAsynchronous
]

{ #category : #'private - notifying' }
GtTextualCoderPromised >> sourceChangedWith: anUpdateStrategy [
	astPromise := nil.
	self notifySourceChangedWith: anUpdateStrategy.
]

{ #category : #'api - accessing' }
GtTextualCoderPromised >> sourceCode [
	<return: #GtCoderSourceCode>

	sourceCode ifNil: [ self sourceCode: (GtCoderExplicitSourceCode new source: '') ].
	^ sourceCode
]

{ #category : #'api - accessing' }
GtTextualCoderPromised >> sourceCode: aGtCoderSourceCode [
	"Set the source code of this coder to a given one and notify about the changes"
	
	self 
		sourceCode: aGtCoderSourceCode 
		withStrategy: GtCoderUpdateStrategy new makeAsynchronous
]

{ #category : #'api - accessing' }
GtTextualCoderPromised >> sourceCode: aGtCoderSourceCode withStrategy: anUpdateStragegy [
	"Set the source code of this coder to a given one and notify about the changes"
	
	sourceCode := aGtCoderSourceCode.
	self sourceChangedWith: anUpdateStragegy.
]

{ #category : #'api - accessing' }
GtTextualCoderPromised >> sourceCodeSynchronously: aGtCoderSourceCode [
	self
		sourceCode: aGtCoderSourceCode 
		withStrategy: GtCoderUpdateStrategy new makeSynchronous
]

{ #category : #'api - text' }
GtTextualCoderPromised >> sourceText [
	<return: #TAsyncPromise>

	self
		deprecated: 'Use #currentSourceText'
		transformWith: '`@receiver sourceText' -> '`@receiver currentSourceText'.

	^ self currentSourceText
]

{ #category : #'api - ast' }
GtTextualCoderPromised >> supportsAstCache [
	"Return true if ast cache should be used, false otherwise"

	^ true
]
