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
				stencil: [ :each | 
					BlTextElement new 
						padding: (BlInsets left: 5 right: 5);
						text: (
							each = GtSearchFilter 
								ifTrue: ['Filter']
								ifFalse: [ 
									(each name gtRemovePrefix: 'GtSearch') 
										gtRemoveSuffix: 'Filter' ])
									asRopedText 
									glamorousRegularFontAndSize ];
				with: self withAllSubclasses.
			m edges 
				stencil: [ :each |
					BlLineElement new 
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 1);
						fromHead: (BlArrowheadTriangle new scale: 4; background: Color white;
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 1))];
				fromNearestTightCircle;
				toLeftCenter;
				connectFrom: #superclass.
			m layout custom: (GtGraphHorizontalTreeLayout new layered horizontalGap: 50; verticalGap: 10).
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
