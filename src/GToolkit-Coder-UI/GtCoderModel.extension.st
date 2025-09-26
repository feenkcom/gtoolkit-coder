Extension { #name : #GtCoderModel }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asCoderViewModel [
	^ self subclassResponsibility
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asElement [
	^ self asCoderViewModel asElement
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asExpandedOnlyElement [
	"Create an element for just the expanded coder without expander"

	^ GtExpandedOnlyCoderElement new
		coderViewModel: self asCoderViewModel;
		yourself
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asStencil [
	^ self
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> coderLook [
	<return: #BrAptitude>

	^ (self attributeNamed: #coderLook ifAbsent: [ nil ]) value
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> coderLook: aLookOrBlock [
	self attributeNamed: #coderLook put: aLookOrBlock
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> create [
	^ self asElement
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> elementClass [
	^ GtExpandableSourceCoderElement
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel class >> gtAstCoderAddOnsFor: aView context: aPhlowContext [
	<gtClassView>
	^ aView forward
		title: 'Coder Addons';
		tooltip: 'The methods that extend the Coder with AddOns';
		priority: 45;
		object: [ (GtSearchMethodsInClassFilter new
				forClass: self;
				includeSuperclass: true)
				& (self astExtensionsPragma gtPragmas | #initializeAddOns: gtImplementors
						| #initializeAddOns:viewModel: gtImplementors) ];
		view: #gtItemsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect Addons'
			action: [ :aButton | 
				aButton phlow
					spawnObject: (GtSearchMethodsInClassFilter new
							forClass: self;
							includeSuperclass: true) & self astExtensionsPragma gtPragmas ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel class >> gtContextMenuAddOnsFor: aView [
	<gtView>
	<gtClassView>
	^ aView forward
		title: 'Menu addons';
		tooltip: 'The methods that extend the Coder with context menu items';
		priority: 45.1;
		object: [ (GtSearchMethodsInClassFilter new
				forClass: self;
				includeSuperclass: true) & self contextMenuAddOnsPragma gtPragmas ];
		view: #gtItemsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect Addons'
			action: [ :aButton |
				aButton phlow spawnObject: (GtSearchMethodsInClassFilter new
					forClass: self;
					includeSuperclass: true) & self contextMenuAddOnsPragma gtPragmas  ]
]
