*GToolkit-Coder
gtMetaFor: aView
	<gtView>
	^ aView explicit
		title: 'Meta';
		priority: 200;
		stencil: [ | element coders |
			element := BlElement new.
			element layout: BlLinearLayout vertical.
			element padding: (BlInsets all: 10).
			element
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ].
			coders := self class selectors asSortedCollection collect: [ :each | GtMethodCoder forMethod: self class >> each ].
			element addChildren: (coders collect: [ :each | each asElement ]).
			element ]