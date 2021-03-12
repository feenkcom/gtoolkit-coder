Extension { #name : #GtPharoSourceCoder }

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> addRefactoringChangesPreview: aRefactoring at: position whenComplete: aBlock [
	self removeRefactoringAttribute.
	aRefactoring isNil
		ifTrue: [ ^ self ].
	(self sourceText from: position to: position)
		attributes:
			{(GtRefactoringChangesAttribute new
				refactoring: aRefactoring;
				completionAction: aBlock)}
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> browseBehaviorAt: aTextPosition [
	"Try to find a behavior reference at a given source text position and request to browse it"

	self
		detectBehaviorAt: aTextPosition
		ifFound: [ :aBehavior |
			self
				notifyToolSpawn: (GtClassCoderTool observedClass: aBehavior)
				withDestination: self spawnDestination  ]
		ifNone: [  ]
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> browseBehaviorIn: aSourceString [
	"Try to find a behavior reference within a given source code and request to browse it"

	self
		detectBehaviorIn: aSourceString
		ifFound: [ :aBehavior |
			self
				notifyToolSpawn: (GtClassCoderTool observedClass: aBehavior)
				withDestination: self spawnDestination  ]
		ifNone: [  ]
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> browseImplementorsAt: aTextPosition [
	"Try to find a message selector at a given source text position and request to browse it"

	self
		detectSelectorAt: aTextPosition
		ifFound: [ :aSelector |
			self
				notifyObjectSpawn: (GtSearchImplementorsFilter selector: aSelector)  ]
		ifNone: [  ]
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> browseImplementorsIn: aSourceString [
	"Try to find a message selector within a given source string and request to browse it"

	self
		detectSelectorIn: aSourceString
		ifFound: [ :aSelector |
			self
				notifyObjectSpawn: (GtSearchImplementorsFilter selector: aSelector) ]
		ifNone: [  ]
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> browseReferencesAt: aTextPosition [
	"Try to create a references filter for an entity at the given text position and request to browse it"

	self
		notifyObjectSpawn: (self detectReferencesFilterAt: aTextPosition
			ifFound: [ :aReferencesFilter | aReferencesFilter ]
			ifNone: [ GtSearchNullFilter new ])
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> browseReferencesIn: aSourceString [
	"Try to create a references filter for an entity within a given source string and request to browse it"

	self
		notifyObjectSpawn: (self detectReferencesFilterIn: aSourceString
			ifFound: [ :aReferencesFilter | aReferencesFilter ]
			ifNone: [ GtSearchNullFilter new ])
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> defaultCoderLook [
	^ [ GtMethodCoderHeaderLook ]
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> initializeShortcuts [
	super initializeShortcuts.

	addOns
		addShortcut: GtSourceCoderBrowseImplementorsShortcut new;
		addShortcut: GtSourceCoderBrowseReferencesShortcut new;
		addShortcut: GtSourceCoderBrowseBehaviorShortcut new;
		addShortcut: GtSourceCoderDiscardChangesShortcut new
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> removeRefactoringAttribute [
	self sourceText
		clearAttributes: [ :each | each class = GtRefactoringChangesAttribute ]
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> withHeader [
	self coderLook: [ GtMethodCoderHeaderLook ]
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSourceCoder >> withoutHeader [
	self coderLook: nil
]
