//
//  Bar.m
//  OrangeEtMoi
//
//  Created by Rémi LAVEDRINE on 10/03/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "OLBar.h"


@implementation OLBar

@synthesize barDelegate = barDelegate_;
@synthesize olGauge, horizontalLegend, verticalLegend;
// @synthesize m_percent, m_horizontalLegend, m_verticalLegend;


#pragma mark -
#pragma mark OLBar object size management

/**
 Calcul la frame contenant la jauge.
 @author : Rémi Lavedrine & Mathieu Mouillière
 @date : 11/03/2011
 @remarks : (facultatif)
 */
- (CGRect)getOLGaugeFrame{
	float OLGaugeFrameHeight = (float)(2.0 / 3.0) * self.frame.size.height;
	float OLGaugeFrameWidth = (float)self.frame.size.width;
	float OLGaugeFrameYOrigin = (float)self.frame.size.height / 6.0;
	//NSLog(@"[OLBar::getOLGaugeFrame] X : %f; Y : %f; Width : %f; Height : %f", 0, OLGaugeFrameYOrigin, OLGaugeFrameWidth, OLGaugeFrameHeight);
	
	CGRect result = CGRectMake(0, OLGaugeFrameYOrigin, OLGaugeFrameWidth, OLGaugeFrameHeight);
	return result;
	
}

/**
 Calcule la frame contenant le label horizontal.
 @author : Rémi Lavedrine & Mathieu Mouillière
 @date : 11/03/2011
 @remarks : (facultatif)
 */
- (CGRect)getHorizontalLabelFrame{
	float verticalLabelHeight = self.frame.size.height / 6.0;
	float verticalLabelWidth = self.frame.size.width;
	float verticalYOrigin = 5.0 * self.frame.size.height / 6.0;
	//NSLog(@"[OLBar::getHorizontalLabelFrame] X : %f; Y : %f; Width : %f; Height : %f", 0, verticalYOrigin, verticalLabelWidth, verticalLabelHeight);
	
	CGRect result = CGRectMake(0, verticalYOrigin, verticalLabelWidth, verticalLabelHeight);
	return result;
}

/**
 Calcule la frame contenant le label vertical.
 @author : Rémi Lavedrine & Mathieu Mouillière
 @date : 11/03/2011
 @remarks : (facultatif)
 */
- (CGRect)getVerticalLabelFrame{
	float verticalLabelHeight = self.frame.size.height / 6.0;
	float verticalLabelWidth = self.frame.size.width;
  int verticalYOrigin = self.frame.size.height - floor((m_percent_ * olGauge.frame.size.height) / 100) - 2 * floor(verticalLabelHeight); // Les deux |verticalLabelHeight| représente la hauteur des labels qui ont la même taille.
	//NSLog(@"[OLBar::getVerticalLabelFrame] X : %f; Y : %f; Width : %f; Height : %f", 0, [self.olGauge getFillView].frame.size.height, verticalLabelWidth, verticalLabelHeight);
	
  CGRect result = CGRectMake(0, verticalYOrigin, verticalLabelWidth, verticalLabelHeight);
	return result;
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code.
    m_percent_ = 0;
		m_horizontalLegend_ = [[NSString alloc] init];
		m_verticalLegend_ = [[NSString alloc] init];
		
		//NSLog(@"[OLBar::initWithContainerFrame] Frame size : %f", self.frame.size.width);
		olGauge = [[OLGauge alloc] initWithFrame:CGRectZero];
    
    horizontalLegend = [[UILabel alloc] init];
    verticalLegend = [[UILabel alloc] init];
    
    UIColor *clearColor = [UIColor clearColor];
    [olGauge setBackgroundColor:clearColor];
    [verticalLegend setBackgroundColor:clearColor];
    [horizontalLegend setBackgroundColor:clearColor];
    [olGauge setOuterShadow:NO];
    [olGauge setInnerShadow:NO];
	}
	return self;
}

- (id)initWithContainerFrame:(CGRect)frame percent:(int)a_percent horizontalLegend:(NSString *)a_horizontalLegend andVerticalLegend:(NSString *)a_verticalLegend{
	self = [super initWithFrame:frame];
	
	if (self) {

		m_percent_ = a_percent;
		m_horizontalLegend_ = [[NSString alloc] initWithString:a_horizontalLegend];
		m_verticalLegend_ = [[NSString alloc] initWithString:a_verticalLegend];
		
		//NSLog(@"[OLBar::initWithContainerFrame] Frame size : %f", self.frame.size.width);
		olGauge = [[OLGauge alloc] initWithFrame:CGRectZero];
    
    horizontalLegend = [[UILabel alloc] init];
    verticalLegend = [[UILabel alloc] init];
    
    UIColor *clearColor = [UIColor clearColor];
    [olGauge setBackgroundColor:clearColor];
    [verticalLegend setBackgroundColor:clearColor];
    [horizontalLegend setBackgroundColor:clearColor];
    [olGauge setOuterShadow:NO];
    [olGauge setInnerShadow:NO];
	}
	
	return self;
}


#pragma mark -
#pragma mark Drawing Bar management

/**
 Dessine une bar avec les légendes correspondantes qui sont stockés dans l'objet.
 @author : Rémi Lavedrine & Mathieu Mouillière
 @date : 11/03/2011
 @remarks : (facultatif)
 */
- (void)drawBar{
  // 1. On crée la Bar (on le fait après la création des labels car la bar est dépendante des informations des labels) et on l'ajoute à la vue.
	[self addSubview:[self createOLGaugeWithPercent:m_percent_ fillDirection:bottomToTop animated:YES]];
  
	// 2. On crée les légendes pour la Bar et on les ajoute à la vue (la position de |verticalLegend| dépend de |olGauge|).
	[self addVerticalLegendWithFrame:[self getVerticalLabelFrame] andLegend:m_verticalLegend_];
	[self addHorizontalLegendWithFrame:[self getHorizontalLabelFrame] andLegend:m_horizontalLegend_];
}

/**
 Crée une jauge à partir d'un pourcentage de remplissage de la jauge et de la direction de "remplissage".
 @author : Rémi Lavedrine & Mathieu Mouillière
 @date : 10/03/2011
 @remarks : [14/03/2011 : RLE & MME] Mise à jour des couleurs de la jauge.
 */
- (OLGauge *)createOLGaugeWithPercent:(int)a_gaugePercent fillDirection:(FillDirection)a_gaugeFillDirection animated:(BOOL)animated{
	[olGauge fillGaugeToValue:a_gaugePercent andFillDirection:a_gaugeFillDirection animated:YES];
  
	return olGauge;
}


/**
 Ajoute le label contenant les informations de la légende des abscisses pour la Bar.
 @author : Rémi Lavedrine & Mathieu Mouillière
 @date : 10/03/2011
 @remarks : (facultatif)
 */
- (void)addHorizontalLegendWithFrame:(CGRect)a_frame andLegend:(NSString *)a_legend{
	[self fillHorizontalLegendWithLegend:a_legend];
	
	[horizontalLegend setFrame:a_frame];
	[self addSubview:horizontalLegend];
}

/**
 Ajoute le label contenant les informations de la légende des ordonnées pour la Bar.
 @author : Rémi Lavedrine & Mathieu Mouillière
 @date : 10/03/2011
 @remarks : (facultatif)
 */
- (void)addVerticalLegendWithFrame:(CGRect)a_frame andLegend:(NSString *)a_legend{
	[self fillVerticalLegendWithLegend:a_legend];
	
	[verticalLegend setFrame:a_frame];
	[self addSubview:verticalLegend];
}

/**
 Fill all the values for a bar.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (void)fillBarWithPercent:(int)percent fillDirection:(FillDirection)theDirection horizontalLegend:(NSString *)horizontalLegendValue andVerticalLegend:(NSString *)verticalLegendValue{
  m_percent_ = percent;
  [olGauge refillGaugeToValue:percent andFillDirection:theDirection animated:NO];
  [self fillHorizontalLegendWithLegend:horizontalLegendValue];
  [self fillVerticalLegendWithLegend:verticalLegendValue];
  [self.verticalLegend setFrame:[self getVerticalLabelFrame]];
  
}

/**
 Fill all the values for a bar.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (void)fillAllBarValuesWithDirection:(FillDirection)theDirection{
  [self fillBarWithPercent:m_percent_ fillDirection:theDirection horizontalLegend:m_horizontalLegend_ andVerticalLegend:m_verticalLegend_];
  
}

/**
 Remplit les informations dans le label de la légende des abscisses.
 @author : Rémi Lavedrine & Mathieu Mouillière
 @date : 10/03/2011
 @remarks : On peut changer la police du texte, la couleur, ...
 */
- (void)fillHorizontalLegendWithLegend:(NSString *)legend{
	[horizontalLegend setText:legend];
	[horizontalLegend setTextColor:[UIColor blackColor]];
	[horizontalLegend setTextAlignment:UITextAlignmentCenter];
	[horizontalLegend setAdjustsFontSizeToFitWidth:YES];
	
	//[horizontalLegend setBackgroundColor:[UIColor brownColor]];
	//horizontalLegend.alpha = 0.5;
}

/**
 Remplit les informations dans le label de la légende des ordonnées.
 @author : Rémi Lavedrine & Mathieu Mouillière
 @date : 10/03/2011
 @remarks : On peut changer la police du texte, la couleur, ...
 */
- (void)fillVerticalLegendWithLegend:(NSString *)legend{
  [verticalLegend setText:legend];
	[verticalLegend setTextColor:[UIColor blackColor]];
	[verticalLegend setTextAlignment:UITextAlignmentCenter];
	[verticalLegend setAdjustsFontSizeToFitWidth:YES];
	
	//[verticalLegend setBackgroundColor:[UIColor brownColor]];
	//verticalLegend.alpha = 0.5;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */


#pragma mark -
#pragma mark Accessors and setters

- (int)percent{
  return m_percent_;
}

- (NSString *)horizontalLegendValue{
  return m_horizontalLegend_;
}

- (NSString *)verticalLegendValue{
  return m_verticalLegend_;
}

- (void)setPercentValue:(int)percent{
  m_percent_ = percent;
}

- (void)setHorizontalLegendValue:(NSString *)horizontalLegendValue{
  m_horizontalLegend_ = horizontalLegendValue;
}

- (void)setVerticalLegendValue:(NSString *)verticalLegendValue{
  m_verticalLegend_ = verticalLegendValue;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[olGauge release];
	[horizontalLegend release];
	[verticalLegend release];
	
	// [m_horizontalLegend_ release];
	// [m_verticalLegend_ release];
	
	[super dealloc];
}


@end
