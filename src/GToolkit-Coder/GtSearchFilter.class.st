Class {
	#name : #GtSearchFilter,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchFilter class >> gtHierarchyFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Hierarchy';
		priority: 0;
		painting: [ :m | 
			m nodes 
				stencil: [ :eachClass | 
					| anExpander text |
					text := (eachClass = GtSearchFilter 
								ifTrue: ['Filter']
								ifFalse: [ 
									(eachClass name gtRemovePrefix: 'GtSearch') 
										gtRemoveSuffix: 'Filter' ])
									asRopedText 
									glamorousRegularFont;
									fontSize: 18.
					anExpander := BrExpander new.
					anExpander vFitContent; hExact: 300.
					anExpander look: BrGlamorousExpanderLook new.
					anExpander header: [ BlTextElement new 
						padding: (BlInsets left: 5 right: 5);
						text: text ].
					anExpander content: [ 
						| container methods |
						container := BlElement new
							layout: BlLinearLayout vertical;
							constraintsDo: [ :c | c vertical fitContent. c horizontal fitContent].
						container addChild: (BlTextElement new 
							padding: (BlInsets left: 5 right: 5);
							text: text).
						methods := eachClass = GtSearchFilter 
							ifTrue: [ (GtSearchFilter methods select: #isOverridden) ]
							ifFalse: [ eachClass methods select: [:method | 
								method gtIsOverridingUpTo: GtSearchFilter ] ].
						methods do: [:aMethod | 
							container addChild: ((GtMethodCoder forMethod: aMethod) asElement)].
						container ].
					anExpander margin: (BlInsets all: 10).
						 ];
				with: self withAllSubclasses.
			m edges 
				stencil: [ :each |
					BlLineElement new 
						zIndex: -1;
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 1);
						fromHead: (BlArrowheadTriangle new scale: 4; background: Color white;
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 1))];
				fromRightCenter;
				toLeftCenter;
				connectFrom: #superclass.
			m layout explicit: (GtGraphHorizontalTreeLayout new layered horizontalGap: 50; verticalGap: 10).
			]
]

{ #category : #'logical operations' }
GtSearchFilter >> & aFilter [
	^ GtSearchIntersectionFilter forFilter: self filter: aFilter
]

{ #category : #evaluating }
GtSearchFilter >> applyInScope: aSearchScope [
	^ self resultType new
		scope: aSearchScope;
		filter: self
]

{ #category : #converting }
GtSearchFilter >> asCoder [
	^ self result asCoder
]

{ #category : #converting }
GtSearchFilter >> asElement [
	^ self asCoder asElement
]

{ #category : #accessing }
GtSearchFilter >> defaultFilterScope [
	^ GtSearchNullFilter new
]

{ #category : #ui }
GtSearchFilter >> gtItemsFor: aView [
	"this is a view that is polymorphic with the one defined in ${method:Collection>>#gtItemsFor:}$"
	<gtView>
	^ self result gtItemsFor: aView
]

{ #category : #accessing }
GtSearchFilter >> highlighter [
	^ nil
]

{ #category : #accessing }
GtSearchFilter >> isEmpty [
	^ self result isEmpty
]

{ #category : #testing }
GtSearchFilter >> matches: anObject [
	self subclassResponsibility
]

{ #category : #'logical operations' }
GtSearchFilter >> not [
	^ GtSearchNegationFilter new originalFilter: self
]

{ #category : #testing }
GtSearchFilter >> notEmpty [
	^ self isEmpty not
]

{ #category : #converting }
GtSearchFilter >> result [
	^ self applyInScope: self defaultFilterScope
]

{ #category : #accessing }
GtSearchFilter >> resultType [
	^ GtSearchNullGroupResult
]

{ #category : #'logical operations' }
GtSearchFilter >> select: aBlock [
	^ self & (GtSearchBlockFilter forBlock: aBlock)
]

{ #category : #accessing }
GtSearchFilter >> size [
	^ self result size
]

{ #category : #'logical operations' }
GtSearchFilter >> | aFilter [
	^ GtSearchUnionFilter forFilter: self filter: aFilter
]
