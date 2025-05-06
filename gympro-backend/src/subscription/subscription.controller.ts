import { Controller, Post, Get, Patch, Body, Param, UseGuards } from '@nestjs/common';
import { SubscriptionService } from './subscription.service';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { Roles } from 'src/auth/roles.decorator';
import { RolesGuard } from 'src/auth/roles.guard';
import { Role } from 'src/user/role.enum';
import { create } from 'domain';
import { CreateSubscriptionDto } from './dto/create-subscription.dto';





@ApiTags('subscriptions')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RolesGuard)
@Roles(Role.ADMIN)
@ApiResponse({ status: 403, description: 'only admin can use it  ' })
@Controller('subscriptions')
export class SubscriptionController {
  constructor(private readonly subscriptionService: SubscriptionService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new subscription' })
  @ApiResponse({ status: 201, description: 'Subscription created successfully' })
  @ApiResponse({ status: 400, description: 'Bad request' })
  @ApiBody({type: CreateSubscriptionDto})
  async createSubscription(@Body() body: { userId: number; planName: string; price: number; durationInDays: number }) {
    return this.subscriptionService.createSubscription(body.userId, body.planName, body.price, body.durationInDays);
  }

  @Get()
  @ApiOperation({ summary: 'Get all subscriptions' })
  @ApiResponse({ status: 200, description: 'List of all subscriptions' })
  async getAllSubscriptions() {
    return this.subscriptionService.getAllSubscriptions();
  }

  @Get(':userId')
  @ApiOperation({ summary: 'Get subscription by user ID' })
  @ApiResponse({ status: 200, description: 'Subscription found' })
  @ApiResponse({ status: 404, description: 'Subscription not found' })
  @ApiBody({ type: Number, description: 'User ID' })
  async getSubscriptionById(@Param('userId') userId: number) {
    return this.subscriptionService.getSubcriptionById(userId);
  }

  @Patch(':id/status')
  @ApiOperation({ summary: 'Update subscription status' })
  @ApiResponse({ status: 200, description: 'Subscription status updated successfully' })
  @ApiResponse({ status: 404, description: 'Subscription not found' })
  @ApiBody({ 
    type: String, 
    description: 'New status for the subscription', 
    examples: { 
      example1: { 
        summary: 'Example payload', 
        value: { status: 'active' } 
      } 
    } 
  })
  async updateSubscriptionStatus(@Param('id') id: number, @Body('status') status: string) {
    return this.subscriptionService.updateSubscriptionStatus(id, status);
  }
}