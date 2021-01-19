Extension { #name : #GtSourceCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> addRefactoringChangesPreview: aRefactoring at: position whenComplete: aBlock [
	self removeRefactoringAttribute.
	aRefactoring isNil
		ifTrue: [ ^ self ].
	(self sourceText from: position to: position)
		attributes:
			{(GtRefactoringChangesAttribute new
				refactoring: aRefactoring;
				completionAction: aBlock)}
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> breadcrumbActions [
	<return: #Array of: #GtSourceCoderBreadcrumbAction>

	^ #()
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> browseBehaviorAt: aTextPosition [
	"Try to find a behavior reference at a given source text position and request to browse it"

	self
		detectBehaviorAt: aTextPosition
		ifFound: [ :aBehavior |
			self
				notifyToolSpawn: (GtClassCoderTool observedClass: aBehavior)
				withDestination: self spawnDestination  ]
		ifNone: [  ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> browseBehaviorIn: aSourceString [
	"Try to find a behavior reference within a given source code and request to browse it"

	self
		detectBehaviorIn: aSourceString
		ifFound: [ :aBehavior |
			self
				notifyToolSpawn: (GtClassCoderTool observedClass: aBehavior)
				withDestination: self spawnDestination  ]
		ifNone: [  ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> browseImplementorsAt: aTextPosition [
	"Try to find a message selector at a given source text position and request to browse it"

	self
		detectSelectorAt: aTextPosition
		ifFound: [ :aSelector |
			self
				notifyObjectSpawn: (GtSearchImplementorsFilter selector: aSelector)  ]
		ifNone: [  ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> browseImplementorsIn: aSourceString [
	"Try to find a message selector within a given source string and request to browse it"

	self
		detectSelectorIn: aSourceString
		ifFound: [ :aSelector |
			self
				notifyObjectSpawn: (GtSearchImplementorsFilter selector: aSelector) ]
		ifNone: [  ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> browseReferencesAt: aTextPosition [
	"Try to create a references filter for an entity at the given text position and request to browse it"

	self
		notifyObjectSpawn: (self detectReferencesFilterAt: aTextPosition
			ifFound: [ :aReferencesFilter | aReferencesFilter ]
			ifNone: [ GtSearchNullFilter new ])
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> browseReferencesIn: aSourceString [
	"Try to create a references filter for an entity within a given source string and request to browse it"

	self
		notifyObjectSpawn: (self detectReferencesFilterIn: aSourceString
			ifFound: [ :aReferencesFilter | aReferencesFilter ]
			ifNone: [ GtSearchNullFilter new ])
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> defaultCoderLook [
	^ [ GtMethodCoderHeaderLook ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> removeRefactoringAttribute [
	self sourceText
		clearAttributes: [ :each | each class = GtRefactoringChangesAttribute ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> withHeader [
	self coderLook: [ GtMethodCoderHeaderLook ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> withoutHeader [
	self coderLook: nil
]
