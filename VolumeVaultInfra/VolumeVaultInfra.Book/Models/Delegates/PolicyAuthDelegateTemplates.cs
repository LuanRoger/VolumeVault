using Microsoft.AspNetCore.Authorization;

namespace VolumeVaultInfra.Book.Models.Delegates;

internal static class PolicyAuthDelegateTemplates
{
    internal static void JWTRequiredIdClaimPolicy(AuthorizationPolicyBuilder policyBuilder)
    {
        policyBuilder.RequireClaim("ID");
    }
}